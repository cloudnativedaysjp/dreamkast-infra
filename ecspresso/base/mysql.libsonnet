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

  // https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
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
        name: 'mysql',
        image: '%s.dkr.ecr.%s.amazonaws.com/ecr-public/docker/library/mysql:%s' % [const.accountID, region, imageTag],
        command: [],
        entryPoint: [],
        essential: true,
        cpu: 256,
        memoryReservation: 512,
        environment: [
          {
            name: 'MYSQL_USER',
            value: 'user',
          },
          {
            name: 'MYSQL_PASSWORD',
            value: 'password',
          },
          {
            name: 'MYSQL_ROOT_PASSWORD',
            value: 'password',
          },
          {
            name: 'MYSQL_DATABASE',
            value: 'dreamkast',
          },
        ],
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
