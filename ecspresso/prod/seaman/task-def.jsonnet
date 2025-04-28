local const = import '../const.libsonnet';
local files_config = importstr './files/config.yaml';
local family = 'dreamkast-prod-seaman';
local executionRoleName = 'dreamkast-prod-ecs-task-execution-role';
local roleName = 'dreamkast-prod-ecs-seaman';

{
  containerDefinitions: [
    {
      local container = self,
      name: 'init',
      image: 'debian:stable-slim',
      essential: false,
      entryPoint: ['bash', '-c'],
      command: ['echo "${CONFIG}" > /mnt/config/config.yaml; cat /mnt/config/config.yaml'],
      environment: [
        {
          name: 'CONFIG',
          value: files_config,
        },
      ],
      mountPoints: [
        {
          containerPath: '/mnt/config',
          sourceVolume: 'config',
        },
      ],
      cpu: 0,
      memory: 512,
    },
    {
      local container = self,
      name: 'seaman',
      image: '607167088920.dkr.ecr.%s.amazonaws.com/seaman:%s' % [const.region, const.imageTags.seaman],
      essential: true,
      command: [
        '--config=/mnt/config/config.yaml',
      ],
      mountPoints: [
        {
          containerPath: '/mnt/config',
          sourceVolume: 'config',
        },
      ],
      secrets: [
        {
          name: 'GITHUB_TOKEN',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:GITHUB_TOKEN::' % [const.region, const.secretManager.releasebot],
        },
        {
          name: 'GITHUB_WEBHOOK_SECRET',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:GITHUB_WEBHOOK_SECRET::' % [const.region, const.secretManager.releasebot],
        },
        {
          name: 'SLACK_BOT_TOKEN',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:SLACK_BOT_TOKEN::' % [const.region, const.secretManager.releasebot],
        },
        {
          name: 'SLACK_APP_TOKEN',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:SLACK_APP_TOKEN::' % [const.region, const.secretManager.releasebot],
        },
      ],

      logConfiguration: {
        logDriver: 'awslogs',
        options: {
          'awslogs-create-group': 'true',
          'awslogs-group': family,
          'awslogs-region': const.region,
          'awslogs-stream-prefix': container.name,
        },
      },

      cpu: 256,
      memory: 512,
      memoryReservation: 512,

      dependsOn: [
        {
          containerName: 'init',
          condition: 'SUCCESS',
        },
      ],
    },
  ],
  family: family,
  cpu: '256',
  memory: '512',
  executionRoleArn: 'arn:aws:iam::607167088920:role/%s' % [executionRoleName],
  taskRoleArn: 'arn:aws:iam::607167088920:role/%s' % [roleName],
  networkMode: 'awsvpc',
  requiresCompatibilities: [
    'FARGATE',
  ],
  volumes: [
    {
      name: 'config',
      host: {},
    },
  ],
}
