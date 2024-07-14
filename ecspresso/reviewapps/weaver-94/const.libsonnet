{
  PR_NAME: 'weaver-94',
  externalEndpoints: {},
  imageTags: {
    dreamkast_weaver: 'cd0e4287fae943d9005f4f37680499d985682747',
    mysql: '8.0.33',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.development.local:3000',
    rdb: 'mysql-weaver-94.development.local',
  },
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
    mysql: 'srv-eg42yns2qt2bb6rh',
  },
  targetGroupArn: {
    dkWeaver: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-weaver-94/7b3d6d992aecea19',
  },
}
