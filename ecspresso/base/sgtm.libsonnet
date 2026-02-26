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
      healthCheckGracePeriodSeconds: 60,
      loadBalancers: [
        {
          containerName: 'sgtm',
          containerPort: 8080,
          targetGroupArn: targetGroupArn,
        },
      ],
    },

  taskDef(
    family,
    cpu=256,
    memory=512,
    taskRoleName,
    executionRoleName,
    region,
    imageTag,
    containerConfig,
    enableLogging=true,
  ):: {
    executionRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, executionRoleName],
    taskRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, taskRoleName],
    family: family,
    cpu: '%s' % [cpu],
    memory: '%s' % [memory],
    networkMode: 'awsvpc',
    requiresCompatibilities: ['FARGATE'],
    volumes: [],
    containerDefinitions: [
      {
        name: 'sgtm',
        image: '%s.dkr.ecr.%s.amazonaws.com/dreamkast-sgtm:%s' % [const.accountID, region, imageTag],
        cpu: cpu,
        memory: memory,
        memoryReservation: memory,
        essential: true,
        restartPolicy: { enabled: true },
        environment: [
          {
            name: 'PORT',
            value: '8080',
          },
          {
            name: 'CONTAINER_CONFIG',
            value: containerConfig,
          },
        ],
        portMappings: [{
          containerPort: 8080,
          hostPort: 8080,
          protocol: 'tcp',
        }],
        healthCheck: {
          command: ['CMD-SHELL', 'curl -f http://localhost:8080/healthz || exit 1'],
          interval: 30,
          timeout: 5,
          retries: 3,
          startPeriod: 60,
        },
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'sgtm',
          },
        },
      } else {},
    ],
  },
}
