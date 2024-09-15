local common = import './common.libsonnet';
local const = import './const.libsonnet';

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
          containerName: 'dreamkast-ui',
          containerPort: 3001,
          targetGroupArn: targetGroupArn,
        },
      ],
    },

  // https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
  taskDef(
    family,
    taskRoleName,
    imageTag,
    region,
    dkEndpoint,
    dkWeaverEndpoint,
    dkUiSecretManagerName,
    enableLogging=false,
    reviewapp=true,
  ):: {
    local root = self,

    //
    // Definitions
    //
    executionRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, const.executionRoleName],
    taskRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, taskRoleName],
    family: family,
    cpu: '256',
    memory: '512',
    networkMode: 'awsvpc',
    requiresCompatibilities: ['FARGATE'],
    volumes: [],
    containerDefinitions: [
      {
        name: 'dreamkast-ui',
        image: '%s.dkr.ecr.%s.amazonaws.com/dreamkast-ui:%s' % [const.accountID, region, imageTag],
        command: [],
        entryPoint: [],
        environment: [
          {
            name: 'NEXT_PUBLIC_API_BASE_URL',
            value: dkEndpoint,
          },
          {
            name: 'NEXT_PUBLIC_DK_URL',
            value: dkEndpoint,
          },
          {
            name: 'NEXT_PUBLIC_WEAVER_URL',
            value: dkWeaverEndpoint,
          },
          {
            name: 'NEXT_PUBLIC_BASE_PATH',
            value: '/%s/ui' % [const.eventName],
          },
        ],
        secrets: [
          // from dreamkast-ui Secret
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:NEXT_PUBLIC_AUTH0_DOMAIN::' % [region, const.accountID, dkUiSecretManagerName],
            name: 'NEXT_PUBLIC_AUTH0_DOMAIN',
          },
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:NEXT_PUBLIC_AUTH0_CLIENT_ID::' % [region, const.accountID, dkUiSecretManagerName],
            name: 'NEXT_PUBLIC_AUTH0_CLIENT_ID',
          },
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:NEXT_PUBLIC_AUTH0_AUDIENCE::' % [region, const.accountID, dkUiSecretManagerName],
            name: 'NEXT_PUBLIC_AUTH0_AUDIENCE',
          },
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:NEXT_PUBLIC_EVENT_SALT::' % [region, const.accountID, dkUiSecretManagerName],
            name: 'NEXT_PUBLIC_EVENT_SALT',
          },
        ],
        essential: true,
        cpu: 256,
        memoryReservation: 512,
        portMappings: [
          {
            containerPort: 3001,
            hostPort: 3001,
            protocol: 'tcp',
          },
        ],
        links: [],
        mountPoints: [],
        volumesFrom: [],
        dependsOn: [],
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'dreamkast-ui',
          },
        },
      } else {},
    ],
  },
}
