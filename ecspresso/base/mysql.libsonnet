local common = import './common.libsonnet';
local const = import './const.libsonnet';

{
  serviceDef(
    region,
    replicas=1,
    subnetIDs=[],
    securityGroupID,
    serviceDiscoveryID,
  )::
    common.serviceDef(
      region,
      replicas,
      subnetIDs,
      securityGroupID,
      serviceDiscoveryID,
    ),

  taskDef(
    family,
    taskRoleName,
    imageTag,
    region,
    enableLogging=false,
  ):: {
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
        name: 'redis',
        image: '%s.dkr.ecr.%s.amazonaws.com/ecr-public/docker/library/mysql:%s' % [const.accountID, region, imageTag],
        command: [],
        entryPoint: [],
        essential: true,
        cpu: 256,
        memoryReservation: 512,
        portMappings: [
          {
            containerPort: 3306,
            hostPort: 3306,
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
            'awslogs-stream-prefix': 'mysql',
          },
        },
      } else {},
    ],
  },
}
