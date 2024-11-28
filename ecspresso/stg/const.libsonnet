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
    dreamkast_ecs: 'b4738fe49870a934474dc0b4adef71996c671182',
    dreamkast_ui: '5a233aae7ee45f1500575f4282da6e6f50f05695',
    dreamkast_weaver: '0ab27f46ebc878aa8a6c258f723c401bf752ca28',
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
    dsn: 'TODO',
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
