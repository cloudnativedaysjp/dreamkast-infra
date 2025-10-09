local common = import './common.libsonnet';
local const = import './const.libsonnet';
local util = import './util.libsonnet';

{
  serviceDef(
    region,
    replicas=1,
    subnetIDs=[],
    securityGroupID,
    targetGroupArn,
  )::
    common.serviceDef(
      region,
      replicas,
      subnetIDs,
      securityGroupID,
    ) + {
      healthCheckGracePeriodSeconds: 0,
      loadBalancers: [
        {
          containerName: 'dkw-serve',
          containerPort: 8080,
          targetGroupArn: targetGroupArn,
        },
      ],
    },

  // https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
  taskDef(
    family,
    cpu=256,
    memory=512,
    taskRoleName,
    executionRoleName,
    imageTag,
    region,
    dkInternalEndpoint,
    rdbInternalEndpoint,
    rdsSecretManagerName,
    enableLogging=false,
    enableOtelcolSidecar=false,
    mackerelSecretManagerName='',
    otelcolConfig='',
    reviewapp=false,
  ):: {
    local root = self,
    //
    // Templates
    //
    containerDefinitionCommon:: {
      local containerDefinitionCommon = self,
      name: error 'must be overridden',
      image: '%s.dkr.ecr.%s.amazonaws.com/dreamkast-weaver:%s' % [const.accountID, region, imageTag],
      entryPoint: [],
      command: [],
      restartPolicy: { enabled: true },

      cpu: error 'must be overridden',
      memory: error 'must be overridden',
      essential: false,

      environment: [
        {
          name: 'DB_ENDPOINT',
          value: rdbInternalEndpoint,
        },
        {
          name: 'DB_PORT',
          value: '3306',
        },
        {
          name: 'DREAMKAST_NAMESPACE',
          value: if family == 'dreamkast-prd-weaver' then 'dreamkast'
          else if family == 'dreamkast-stg-weaver' then 'dreamkast-staging'
          else family,
        },
      ] + if reviewapp == true then [
        {
          name: 'DB_USER',
          value: 'root',
        },
        {
          name: 'DB_PASSWORD',
          value: 'password',
        },
      ] else [],
      secrets: if reviewapp == false then [
        // from rds-secret Secret
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:username::' % [region, const.accountID, rdsSecretManagerName],
          name: 'DB_USER',
        },
        {
          valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:password::' % [region, const.accountID, rdsSecretManagerName],
          name: 'DB_PASSWORD',
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
      root.containerDefinitionCommon {
        name: 'dkw-dbmigrate',
        entryPoint: ['/dkw', 'dbmigrate'],
        cpu: 0,
        memory: memory,
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'dkw-dbmigrate',
          },
        },
      } else {},
      root.containerDefinitionCommon {
        name: 'dkw-serve',
        entryPoint: ['/dkw', 'serve'],
        command: ['--port=8080'],
        cpu: cpu,
        memory: util.mainContainerMemory(memory, false, enableOtelcolSidecar),
        memoryReservation: util.mainContainerMemoryReservation(memory, false, enableOtelcolSidecar),
        essential: true,
        environment: root.containerDefinitionCommon.environment + [
          {
            name: 'DREAMKAST_ADDR',
            value: dkInternalEndpoint,
          },
          {
            name: 'AWS_REGION',  // IVS REGION
            value: 'us-east-1',
          },
          //{
          //  name: 'PROM_PUSHGATEWAY_ENDPOINT',
          //  value: 'http://prometheus-pushgateway.monitoring.svc.cluster.local:9091',
          //},
        ],
        portMappings: [{
          containerPort: 8080,
          hostPort: 8080,
          protocol: 'tcp',
        }],
        dependsOn: [
          {
            containerName: 'dkw-dbmigrate',
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
            'awslogs-stream-prefix': 'dkw-serve',
          },
        },
      } else {},
    ] + (
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
        } else {},
      ] else []
    ),
  },
}
