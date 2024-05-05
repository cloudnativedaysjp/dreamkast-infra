{
  //
  // Platform information
  //
  region: 'us-west-2',
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',  // dreamkast-dev-vpc-public-us-west-2a
    'subnet-0d07831c8fc073511',  // dreamkast-dev-vpc-public-us-west-2b
    'subnet-033491d41490494b6',  // dreamkast-dev-vpc-public-us-west-2c
  ],
  privateSubnetIDs: [
    'subnet-05d0a81dafd9409f9',  // dreamkast-dev-vpc-private-us-west-2a
    'subnet-042770b2f29661e8e',  // dreamkast-dev-vpc-private-us-west-2b
    'subnet-0d95068828df7cc3e',  // dreamkast-dev-vpc-private-us-west-2c
  ],
  secretManager: {
    dk: 'dreamkast/staging-env-SID4P1',
    dkUi: 'dreamkast-ui/staging-env-3nBcuB',
    railsApp: 'dreamkast/rails-app-secret-SqidNC',
    rds: 'dreamkast-stg-rds-secret-0dsVhM',
  },
  s3: {
    dreamkast: {
      name: 'dreamkast-stg-bucket',
      region: 'us-west-2',
    },
  },
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  serviceDiscovery: {
    dk: 'srv-vb6353dahtneltjh',
    redis: 'srv-bbwl53e4dfx2omtm',
  },
  sentry: {
    dsn: 'TODO',
  },

  //
  // Endpoints
  //
  externalEndpoints: {
    dk: 'https://staging.dev.cloudnativedays.jp',
    dkApi: 'https://api.stg.cloudnativedays.jp',  // MEMO: this value may be garbage
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.staging.local',
    rdb: 'dreamkast-stg-rds.cctlaulyxvbk.us-west-2.rds.amazonaws.com',
    redis: 'redis://redis.staging.local',
  },

  //
  // Container Images
  //
  imageTags: {
    dreamkast_ecs: '28a1050aedfaa0cae4ff58c4dfbf44c653f82d39',
    dreamkast_ui: 'migrate-to-ecs',
    dreamkast_weaver: 'migrate-to-ecs',
    redis: '6.0',
  },
}
