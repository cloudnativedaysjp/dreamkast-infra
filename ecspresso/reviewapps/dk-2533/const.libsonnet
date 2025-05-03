{
  PR_NAME: 'dk-2533',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dkApi: 'https://api.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: 'commit-d2bd0ac5ee7e063141d5938ecb2f6a74ba869f98',
    mysql: '8.0.33',
    redis: '6.0',
  },
  internalEndpoints: {
    rdb: 'mysql-dk-2533.development.local',
    redis: 'redis://redis-dk-2533.development.local',
  },
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',
    'subnet-0d07831c8fc073511',
    'subnet-033491d41490494b6',
  ],
  region: 'us-west-2',
  s3: {
    dreamkast: {
      name: 'dreamkast-dev-bucket',
      region: 'us-west-2',
    },
  },
  secretManager: {
    dk: 'dreamkast/reviewapp-env-yGJKrj',
    railsApp: 'dreamkast/rails-app-secret-SqidNC',
  },
  sentry: {
    dsn: 'TODO',
  },
  serviceDiscovery: {
    mysql: 'srv-raup7zytfqae37wk',
    redis: 'srv-edyir37nkmp3sfyd',
  },
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  targetGroupArn: {
    dk: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2533/94e8bbb9c527ae50',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
