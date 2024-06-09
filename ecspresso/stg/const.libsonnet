{
  externalEndpoints: {
    dk: 'https://staging.dev.cloudnativedays.jp',
    dkApi: 'https://api.stg.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: '165f93ac44e6a207c718997c2b8e03cfedfd81c6',
    dreamkast_ui: '7c0d228eaad7235384cdb3856f734edee791f504',
    dreamkast_weaver: 'cab9718abcd00e7b0487108364ab781506c39ff5',
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
