local common = import './common.libsonnet';
local const = import './const.libsonnet';
local util = import './util.libsonnet';

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

  // https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
  taskDef(
    family,
    cpu=256,
    memory=1024,
    taskRoleName,
    executionRoleName,
    imageTag,
    region,
    dkApiEndpoint,
    dkWeaverEndpoint,
    rdbInternalEndpoint,
    redisInternalEndpoint,
    s3BucketName,
    s3BucketRegion,
    sqsFifoQueueName,
    sentryDsn,
    railsAppSecretManagerName,
    rdsSecretManagerName,
    dreamkastSecretManagerName,
    enableLogging=false,
    enableLokiLogging=false,
    lokiEndpoint='',
    enableOtelcolSidecar=false,
    mackerelSecretManagerName='',
    otelcolConfig='',
    reviewapp=false,
  ):: {
    local root = self,
    assert (enableLogging && enableLokiLogging) != true,

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
      memory: error 'must be overridden',
      //memoryReservation: error 'must be overridden',
      essential: false,
      restartPolicy: { enabled: true },

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
          value: if family == 'dreamkast-prod-dk' then 'dreamkast'
          else if family == 'dreamkast-stg-dk' then 'dreamkast-staging'
          else family,
        },
      ] + if reviewapp == true then [
        {
          name: 'REVIEW_APP',
          value: 'true',
        },
      ] else [],
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
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:PRINTNODE_API_KEY::' % [region, const.accountID, dreamkastSecretManagerName],
          name: 'PRINTNODE_API_KEY',
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
    executionRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, executionRoleName],
    taskRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, taskRoleName],
    family: family,
    cpu: '%s' % [cpu],
    memory: '%s' % [memory],
    networkMode: 'awsvpc',
    requiresCompatibilities: ['FARGATE'],
    volumes: [],
    containerDefinitions: [
      //
      // container: dreamkast-initdb
      //
      root.containerDefinitionCommon {
        name: 'initdb',
        entryPoint: ['/bin/bash', '-c'],
        command: ['bundle exec rails db:migrate; bundle exec rails db:seed;'],
        cpu: 0,
        memory: memory,
        dependsOn: if enableLokiLogging then [
          {
            containerName: 'log_router',
            condition: 'START',
          },
        ] else [],
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'dreamkast',
          },
        },
      } else if enableLokiLogging then {
        assert lokiEndpoint != '',
        logConfiguration: {
          logDriver: 'awsfirelens',
          options: {
            RemoveKeys: 'container_id,ecs_task_arn',
            LineFormat: 'key_value',
            Labels: '{job="%s"}' % [family],
            LabelKeys: 'container_name,ecs_task_definition,source,ecs_cluster',
            Url: '%s/loki/api/v1/push' % [lokiEndpoint],
            Name: 'grafana-loki',
          },
        },
      } else {},
      //
      // container: dreamkast
      //
      root.containerDefinitionCommon {
        name: 'dreamkast',
        cpu: util.mainContainerCPU(cpu, enableLokiLogging, enableOtelcolSidecar),
        memory: util.mainContainerMemory(memory, enableLokiLogging, enableOtelcolSidecar),
        memoryReservation: util.mainContainerMemoryReservation(memory, enableLokiLogging, enableOtelcolSidecar),
        essential: true,
        environment: root.containerDefinitionCommon.environment + [
          {
            name: 'OTEL_ENDPOINT',
            value: 'http://localhost:4318/v1/traces',
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
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'dreamkast',
          },
        },
      } else if enableLokiLogging then {
        assert lokiEndpoint != '',
        logConfiguration: {
          logDriver: 'awsfirelens',
          options: {
            RemoveKeys: 'container_id,ecs_task_arn',
            LineFormat: 'key_value',
            Labels: '{job="%s"}' % [family],
            LabelKeys: 'container_name,ecs_task_definition,source,ecs_cluster',
            Url: '%s/loki/api/v1/push' % [lokiEndpoint],
            Name: 'grafana-loki',
          },
        },
      } else {},
    ] + (
      if enableLokiLogging then [
        //
        // container: fluent-bit-plugin-loki
        //
        assert lokiEndpoint != '';
        root.containerDefinitionCommon {
          name: 'log_router',
          user: '0',
          image: 'grafana/fluent-bit-plugin-loki:2.9.10',
          cpu: const.fluentBitLokiResources.cpu,
          memory: const.fluentBitLokiResources.memory,
          memoryReservation: const.fluentBitLokiResources.memoryReservation,
          environment: [],
          secrets: [],
          firelensConfiguration: {
            type: 'fluentbit',
            options: {
              'enable-ecs-log-metadata': 'true',
            },
          },
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
      ] else []
    ) + (
      if enableOtelcolSidecar then [
        //
        // container: dreamkast-otelcol
        //
        assert mackerelSecretManagerName != '';
        root.containerDefinitionCommon {
          name: 'otelcol',
          image: '%s.dkr.ecr.%s.amazonaws.com/dreamkast-otelcol:branch-main' % [const.accountID, region],
          cpu: const.otelcolSidecarResources.cpu,
          memory: const.otelcolSidecarResources.memory,
          memoryReservation: const.otelcolSidecarResources.memoryReservation,
          entryPoint: ['bash', '-c'],
          command: ['echo "${OTELCOL_CONFIG}" > /mnt/otelcol-config.yaml; /usr/local/bin/otelcol --config=/mnt/otelcol-config.yaml'],
          environment: [
            {
              name: 'OTELCOL_CONFIG',
              value: otelcolConfig,
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
              'awslogs-stream-prefix': 'otelcol',
            },
          },
        } else if enableLokiLogging then {
          assert lokiEndpoint != '',
          logConfiguration: {
            logDriver: 'awsfirelens',
            options: {
              RemoveKeys: 'container_id,ecs_task_arn',
              LineFormat: 'key_value',
              Labels: '{job="%s"}' % [family],
              LabelKeys: 'container_name,ecs_task_definition,source,ecs_cluster',
              Url: '%s/loki/api/v1/push' % [lokiEndpoint],
              Name: 'grafana-loki',
            },
          },
        } else {},
      ] else []
    ),
  },
}
