{
  externalEndpoints: {
    dk: 'https://staging.dev.cloudnativedays.jp',
    dkApi: 'https://api.stg.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: '28a1050aedfaa0cae4ff58c4dfbf44c653f82d39',
    dreamkast_ui: 'baf24a37bcbeb8943f3ff3534303668a72d2190b',
    dreamkast_weaver: 'migrate-to-ecs',
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
}
