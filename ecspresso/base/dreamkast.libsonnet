local common = import './common.libsonnet';
local const = import './const.libsonnet';

{
  serviceDef(
    region,
    replicas=1,
    subnetIDs=[],
    securityGroupID,
    serviceDiscoveryID='',
    targetGroupArn,
  )::
    common.serviceDef(
      region,
      replicas,
      subnetIDs,
      securityGroupID,
      serviceDiscoveryID,
    ) + {
      healthCheckGracePeriodSeconds: 0,
      loadBalancers: [
        {
          containerName: 'dreamkast',
          containerPort: 3000,
          targetGroupArn: targetGroupArn,
        },
      ],
    },

  # https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
  taskDef(
    family,
    taskRoleName,
    imageTag,
    region,
    dkApiEndpoint,
    dkWeaverEndpoint,
    lokiEndpoint,
    rdbInternalEndpoint,
    redisInternalEndpoint,
    s3BucketName,
    s3BucketRegion,
    sqsFifoQueueName,
    sentryDsn,
    railsAppSecretManagerName,
    rdsSecretManagerName,
    dreamkastSecretManagerName,
    mackerelSecretManagerName,
    enableLogging=false,
    reviewapp=false,
  ):: {
    local root = self,
    //
    // Templates
    //
    containerDefinitionCommon:: {
      local containerDefinitionCommon = self,
      name: error 'must be overridden',
      image: '%s.dkr.ecr.%s.amazonaws.com/dreamkast-ecs:%s' % [const.accountID, region, imageTag],
      entryPoint: [],
      command: [],

      cpu: error 'must be overridden',
      memoryReservation: error 'must be overridden',
      essential: false,

      environment: [
        {
          name: 'RAILS_ENV',
          value: 'production',
        },
        {
          name: 'MYSQL_HOST',
          value: rdbInternalEndpoint,
        },
        {
          name: 'MYSQL_DATABASE',
          value: 'dreamkast',
        },
        {
          name: 'REDIS_URL',
          value: redisInternalEndpoint,
        },
        {
          name: 'SENTRY_DSN',
          value: sentryDsn,
        },
        {
          name: 'S3_BUCKET',
          value: s3BucketName,
        },
        {
          name: 'S3_REGION',
          value: s3BucketRegion,
        },
        {
          name: 'DREAMKAST_NAMESPACE',
          value: if family == 'dreamkast-prd-ui' then 'dreamkast'
          else if family == 'dreamkast-stg-ui' then 'dreamkast-staging'
          else family,
        },
      ],
      secrets: [
        // from rails-app-secret Secret
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s' % [region, const.accountID, railsAppSecretManagerName],
          name: 'RAILS_MASTER_KEY',
        },
        // from dreamkast Secret
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:AUTH0_CLIENT_ID::' % [region, const.accountID, dreamkastSecretManagerName],
          name: 'AUTH0_CLIENT_ID',
        },
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:AUTH0_CLIENT_SECRET::' % [region, const.accountID, dreamkastSecretManagerName],
          name: 'AUTH0_CLIENT_SECRET',
        },
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:AUTH0_DOMAIN::' % [region, const.accountID, dreamkastSecretManagerName],
          name: 'AUTH0_DOMAIN',
        },
      ] + if reviewapp == false then [
        // from rds-secret Secret
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:username::' % [region, const.accountID, rdsSecretManagerName],
          name: 'MYSQL_USER',
        },
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:password::' % [region, const.accountID, rdsSecretManagerName],
          name: 'MYSQL_PASSWORD',
        },
      ] else [],

      portMappings: [],
      links: [],
      mountPoints: [],
      volumesFrom: [],
      dependsOn: [],
    },

    //
    // Definitions
    //
    executionRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, const.executionRoleName],
    taskRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, taskRoleName],
    family: family,
    cpu: '512',
    memory: '1024',
    networkMode: 'awsvpc',
    requiresCompatibilities: ['FARGATE'],
    volumes: [],
    containerDefinitions: [
      root.containerDefinitionCommon {
        name: 'initdb',
        entryPoint: ['/bin/bash', '-c'],
        command: ['bundle exec rails db:migrate; bundle exec rails db:seed;'],
        cpu: 64,
        memoryReservation: 128,
        dependsOn: [
          {
            containerName: 'log_router',
            condition: 'HEALTHY',
          },
        ]
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awsfirelens',
          options: {
            'RemoveKeys': 'container_id,ecs_task_arn',
            'LineFormat': 'key_value',
            'Labels': '{job=\"%s\"}' % [family],
            'LabelKeys': 'container_name,ecs_task_definition,source,ecs_cluster',
            'Url': '%s/loki/api/v1/push' % [lokiEndpoint],
            'Name': 'grafana-loki'
          },
        },
      } else {},
      root.containerDefinitionCommon {
        name: 'dreamkast',
        cpu: 448,
        memoryReservation: 896,
        essential: true,
        environment: root.containerDefinitionCommon.environment + [
          {
            name: 'OTEL_SERVICE_NAME',
            value: 'dreamkast',
          },
          {
            name: 'AWS_REGION',
            value: region,
          },
          {
            name: 'SQS_FIFO_QUEUE_URL',
            value: 'https://sqs.%s.amazonaws.com/%s/%s.fifo' % [region, const.accountID, sqsFifoQueueName],
          },
          {
            name: 'DREAMKAST_API_ADDR',
            value: dkApiEndpoint,
          },
          {
            name: 'DREAMKAST_WEAVER_ADDR',
            value: dkWeaverEndpoint,
          },
          {
            name: 'DREAMKAST_UI_BASE_URL',
            value: '*',
          },
        ],
        portMappings: [{
          containerPort: 3000,
          hostPort: 3000,
          protocol: 'tcp',
        }],
        dependsOn: [
          {
            containerName: 'initdb',
            condition: 'SUCCESS',
          },
        ],
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awsfirelens',
          options: {
            'RemoveKeys': 'container_id,ecs_task_arn',
            'LineFormat': 'key_value',
            'Labels': '{job=\"%s\"}' % [family],
            'LabelKeys': 'container_name,ecs_task_definition,source,ecs_cluster',
            'Url': '%s/loki/api/v1/push' % [lokiEndpoint],
            'Name': 'grafana-loki'
          },
        },
      } else {},
      root.containerDefinitionCommon {
        name: 'log_router',
        image: 'grafana/fluent-bit-plugin-loki:2.9.10',
        cpu: 0,
        memoryReservation: 50,
        environment: [],
        secrets: [],
        firelensConfiguration: {
          type: 'fluentbit',
          options: {
            'enable-ecs-log-metadata': 'true',
          }
        }
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'firelens',
          },
        },
      } else {},
      root.containerDefinitionCommon {
        name: 'mackerel-container-agent',
        image: 'mackerel/mackerel-container-agent:latest',
        cpu: 0,
        memoryReservation: 128,
        environment: [
          {
            name: 'MACKEREL_CONTAINER_PLATFORM',
            value: 'ecs',
          },
        ],
        secrets: [
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s' % [region, const.accountID, mackerelSecretManagerName],
            name: 'MACKEREL_APIKEY',
          },
        ],
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'mackerel-agent',
          },
        },
      } else {},
    ],
  },
}
