{
  externalEndpoints: {
    dk: 'https://staging.dev.cloudnativedays.jp',
    dkApi: 'https://api.stg.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
    loki: 'https://stg.loki.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: 'c68854f0ab54fc0ea8358fa28111fee59d57e0d0',
    dreamkast_ui: '26c59eb7def8e4f3812a90703b837d9828cf5922',
    dreamkast_weaver: '2e6e6d9bec2ae0c4d61bc14ac70231eaea623dec',
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
}
