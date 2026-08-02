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
    ) + {
      healthCheckGracePeriodSeconds: 0,
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
    cpuArchitecture='X86_64',
    enableLogging=false,
  ):: {
    executionRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, executionRoleName],
    taskRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, taskRoleName],
    family: family,
    cpu: '%s' % [cpu],
    memory: '%s' % [memory],
    networkMode: 'awsvpc',
    requiresCompatibilities: ['FARGATE'],
    runtimePlatform: {
      cpuArchitecture: cpuArchitecture,
      operatingSystemFamily: 'LINUX',
    },
    volumes: [],
    containerDefinitions: [
      {
        name: 'mysql',
        image: '%s.dkr.ecr.%s.amazonaws.com/ecr-public/docker/library/mysql:%s' % [const.accountID, region, imageTag],
        // solid_cable 用の専用データベース(dreamkast_cable)を review app 用 MySQL にも作成する。
        // 公式 MySQL イメージは MYSQL_DATABASE を1つしか作らないため、
        // 初期化スクリプト(/docker-entrypoint-initdb.d)を注入してから mysqld を起動する。
        entryPoint: ['bash', '-c'],
        command: [
          "echo \"CREATE DATABASE IF NOT EXISTS dreamkast_cable CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci; GRANT ALL PRIVILEGES ON dreamkast_cable.* TO 'user'@'%';\" > /docker-entrypoint-initdb.d/10-create-cable-db.sql && exec docker-entrypoint.sh mysqld",
        ],
        essential: true,
        restartPolicy: { enabled: true },
        cpu: cpu,
        memory: memory,
        memoryReservation: memory,
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
