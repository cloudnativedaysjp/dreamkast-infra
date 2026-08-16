local const = import '../const.libsonnet';
local family = 'dreamkast-prod-sessions-trim';
// この rake task は AWS API を呼ばないため、専用ロールは作らず
// post-registration のロール/SGを流用する(いずれも SSM 用の権限と全許可 egress のみ)。
local roleName = 'dreamkast-prod-ecs-post-registration';

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
      // activerecord-session_store は期限切れセッションを自動削除しないため、
      // gem が提供する db:sessions:trim を日次で実行して sessions テーブルの肥大化を防ぐ。
      command: [
        'bundle exec rake db:sessions:trim',
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
          // session_store の expire_after は 1 週間。余裕を見て 14 日より古い行を削除する。
          name: 'SESSION_DAYS_TRIM_THRESHOLD',
          value: '14',
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
          value: 'dreamkast',
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
  executionRoleArn: 'arn:aws:iam::607167088920:role/%s' % [const.executionRoleName],
  taskRoleArn: 'arn:aws:iam::607167088920:role/%s' % [roleName],
  networkMode: 'awsvpc',
  requiresCompatibilities: [
    'FARGATE',
  ],
  runtimePlatform: {
    cpuArchitecture: 'ARM64',
    operatingSystemFamily: 'LINUX',
  },
  volumes: [],
}
