{
  PR_NAME: 'dk-2497',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dkApi: 'https://api.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: '4c3053fe52ef174bd94d4601ac03940c9f46c557',
    mysql: '8.0.33',
    redis: '6.0',
  },
  internalEndpoints: {
    rdb: 'mysql-dk-2497.development.local',
    redis: 'redis://redis-dk-2497.development.local',
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
    mysql: 'srv-nrxq5tcgnar2oqcn',
    redis: 'srv-5s6cejyu44ywrz6i',
  },
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  targetGroupArn: {
    dk: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2497/c9d98a1c852ea1af',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
