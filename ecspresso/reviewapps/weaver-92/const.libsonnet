{
  PR_NAME: 'weaver-92',
  externalEndpoints: {},
  imageTags: {
    dreamkast_weaver: 'cd5a434cb0362d401da6aa23b8d5a1777f184246',
    mysql: '8.0.33',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.development.local:3000',
    rdb: 'mysql-weaver-92.development.local',
  },
  privateSubnetIDs: [
    'subnet-05d0a81dafd9409f9',
    'subnet-042770b2f29661e8e',
    'subnet-0d95068828df7cc3e',
  ],
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',
    'subnet-0d07831c8fc073511',
    'subnet-033491d41490494b6',
  ],
  region: 'us-west-2',
  secretManager: {
    rds: 'dreamkast-stg-rds-secret-0dsVhM',
  },
  serviceDiscovery: {
    mysql: 'srv-f7pduvwkh3v4bzmb',
  },
  targetGroupArn: {
    dkWeaver: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-weaver-92/3f7edd641e0d4ea3',
  },
}
