{
  PR_NAME: error 'you must replace this value',

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
    dk: 'dreamkast/development-env-SID4P1',
    railsApp: 'dreamkast/rails-app-secret-SqidNC',
    rds: 'dreamkast-stg-rds-secret-0dsVhM',
  },
  s3: {
    dreamkast: {
      name: 'dreamkast-dev-bucket',
      region: 'us-west-2',
    },
  },
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  targetGroupArn: {
    dk: error 'you must replace this value',
  },
  serviceDiscovery: {
    mysql: error 'you must replace this value',
    redis: error 'you must replace this value',
  },
  sentry: {
    dsn: 'TODO',
  },

  //
  // Endpoints
  //
  externalEndpoints: {
    dkApi: 'https://api.dev.cloudnativedays.jp',  // MEMO: this value may be garbage
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  internalEndpoints: {
    rdb: 'mysql-%s.development.local' % [$.PR_NAME],
    redis: 'redis://redis-%s.development.local' % [$.PR_NAME],
  },

  //
  // Container Images
  //
  imageTags: {
    dreamkast_ecs: error 'you must replace this value',
    redis: '6.0',
    mysql: '8.0.33',
  },
}
