{
  cluster: 'dreamkast-stg',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dk: 'https://staging.dev.cloudnativedays.jp',
    dkApi: 'https://api.stg.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
    loki: 'https://stg.loki.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: 'commit-f6c8b3d17a06fcd806ad80b3599ed0a2196f7ea9',
    dreamkast_ui: '42a5b2552f6a0fd490944b97b7547fc00ac31672',
    dreamkast_weaver: '06162294997833338a2cfa94d35db4faa5aaacc3',
    redis: '6.0',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.staging.local',
    rdb: 'dreamkast-stg-rds.cctlaulyxvbk.us-west-2.rds.amazonaws.com',
    redis: 'redis://redis.staging.local',
  },
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',
    'subnet-0d07831c8fc073511',
    'subnet-033491d41490494b6',
  ],
  region: 'us-west-2',
  s3: {
    dreamkast: {
      name: 'dreamkast-stg-bucket',
      region: 'us-west-2',
    },
  },
  secretManager: {
    dk: 'dreamkast/staging-env-SID4P1',
    dkUi: 'dreamkast-ui/staging-env-3nBcuB',
    mackerel: 'observability/mackerel/api-key-tjOHnb',
    railsApp: 'dreamkast/rails-app-secret-SqidNC',
    rds: 'dreamkast-stg-rds-secret-0dsVhM',
  },
  sentry: {
    dsn: 'https://3ae606172e0b82cec45c674e905ab233@o414348.ingest.us.sentry.io/4509089530904576',
  },
  serviceDiscovery: {
    dk: 'srv-vb6353dahtneltjh',
    redis: 'srv-bbwl53e4dfx2omtm',
  },
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
