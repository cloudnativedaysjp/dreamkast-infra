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
    dreamkast_ecs: 'main-ff4197136ec89151b78070749381ad357c7a9c96',
    dreamkast_ui: 'main-1190cbd29f929155e547c9c03b302e84802b7ede',
    dreamkast_weaver: 'main-3e275522c69d061d27a6f950a816852fcdf51a9b',
    redis: '6.0',
    sgtm: '4.2.0',
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
    sgtm: 'dreamkast/sgtm-config-staging-69uWUR',
  },
  sentry: {
    dsn: 'https://3ae606172e0b82cec45c674e905ab233@o414348.ingest.us.sentry.io/4509089530904576',
  },
  serviceDiscovery: {
    dk: 'srv-vb6353dahtneltjh',
    redis: 'srv-bbwl53e4dfx2omtm',
  },
  sgtm: {},
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
