local const = import '../const.libsonnet';
local family = 'dreamkast-prod-post-registration';
local executionRoleName = 'dreamkast-prod-ecs-task-execution-role';
local roleName = 'dreamkast-prod-ecs-harvestjob';

{
  containerDefinitions: [
    {
      local container = self,

      name: 'dreamkast',
      image: '607167088920.dkr.ecr.%s.amazonaws.com/dreamkast-ecs:%s' % [const.region, const.imageTags.dreamkast_ecs],
      essential: true,
      entryPoint: [
        '/bin/bash',
        '-c',
      ],
      command: [
        'bundle exec rake util:post_number_of_registrants_to_slack',
      ],
      environment: [
        {
          name: 'RAILS_ENV',
          value: 'production',
        },
        {
          name: 'MYSQL_HOST',
          value: const.internalEndpoints.rdb,
        },
        {
          name: 'MYSQL_DATABASE',
          value: 'dreamkast',
        },
        {
          name: 'REDIS_URL',
          value: const.internalEndpoints.redis,
        },
        {
          name: 'SENTRY_DSN',
          value: const.sentry.dsn,
        },
        {
          name: 'S3_BUCKET',
          value: 'dreamkast-prod-bucket',
        },
        {
          name: 'S3_REGION',
          value: const.region,
        },
        {
          name: 'DREAMKAST_NAMESPACE',
          value: 'dreamkast-prod-dk',
        },
      ],
      secrets: [
        {
          name: 'RAILS_MASTER_KEY',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s' % [const.region, const.secretManager.railsApp],
        },
        {
          name: 'AUTH0_CLIENT_ID',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:AUTH0_CLIENT_ID::' % [const.region, const.secretManager.dk],
        },
        {
          name: 'AUTH0_CLIENT_SECRET',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:AUTH0_CLIENT_SECRET::' % [const.region, const.secretManager.dk],
        },
        {
          name: 'AUTH0_DOMAIN',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:AUTH0_DOMAIN::' % [const.region, const.secretManager.dk],
        },
        {
          name: 'SLACK_TOKEN',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:SLACK_TOKEN::' % [const.region, const.secretManager.dk],
        },
        {
          name: 'MYSQL_USER',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:username::' % [const.region, const.secretManager.rds],
        },
        {
          name: 'MYSQL_PASSWORD',
          valueFrom: 'arn:aws:secretsmanager:%s:607167088920:secret:%s:password::' % [const.region, const.secretManager.rds],
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
  volumes: [],
}
