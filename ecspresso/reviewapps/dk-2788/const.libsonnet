{
  PR_NAME: 'dk-2788',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dkApi: 'https://api.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: 'commit-d2190f3953b5f507277270c64e29494e5fbf7c64',
    mysql: '8.0.33',
    redis: '6.0',
  },
  internalEndpoints: {
    rdb: 'mysql-dk-2788.development.local',
    redis: 'redis://redis-dk-2788.development.local',
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
    mysql: 'srv-jus3qsihs4dbmmku',
    redis: 'srv-wgiwkr7skziek4mj',
  },
  sqs: {
    fifo: 'dreamkast-dev-fifo-queue',
  },
  targetGroupArn: {
    dk: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2788/8f909d6b25747376',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
