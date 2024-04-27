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
    rds: 'dreamkast-stg-rds-secret-0dsVhM',
  },
  targetGroupArn: {
    dkWeaver: error 'you must replace this value',
  },
  serviceDiscovery: {
    mysql: error 'you must replace this value',
  },

  //
  // Endpoints
  //
  externalEndpoints: {
  },
  internalEndpoints: {
    dk: 'http://dreamkast.staging.local:3000',
    rdb: 'mysql-%s.development.local' % [self.PR_NAME],
  },

  //
  // Container Images
  //
  imageTags: {
    dreamkast_weaver: error 'you must replace this value',
    mysql: '8.0.33',
  },
}
