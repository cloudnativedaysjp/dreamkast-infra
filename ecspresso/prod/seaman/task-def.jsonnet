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
      //image: '607167088920.dkr.ecr.ap-northeast-1.amazonaws.com/seaman:%s' % [const.imageTags.seaman],
      image: 'public.ecr.aws/f5j9d0q5/seaman:%s' % [const.imageTags.seaman],
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
          valueFrom: 'arn:aws:secretsmanager:ap-northeast-1:607167088920:secret:%s:GITHUB_TOKEN::' % [const.secretManager.releasebot],
        },
        {
          name: 'GITHUB_WEBHOOK_SECRET',
          valueFrom: 'arn:aws:secretsmanager:ap-northeast-1:607167088920:secret:%s:GITHUB_WEBHOOK_SECRET::' % [const.secretManager.releasebot],
        },
        {
          name: 'SLACK_BOT_TOKEN',
          valueFrom: 'arn:aws:secretsmanager:ap-northeast-1:607167088920:secret:%s:SLACK_BOT_TOKEN::' % [const.secretManager.releasebot],
        },
        {
          name: 'SLACK_APP_TOKEN',
          valueFrom: 'arn:aws:secretsmanager:ap-northeast-1:607167088920:secret:%s:SLACK_APP_TOKEN::' % [const.secretManager.releasebot],
        },
      ],

      logConfiguration: {
        logDriver: 'awslogs',
        options: {
          'awslogs-create-group': 'true',
          'awslogs-group': family,
          'awslogs-region': 'ap-northeast-1',
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
    },
  ],
}
