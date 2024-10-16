{
  PR_NAME: 'dk-2416',
  externalEndpoints: {
    dkApi: 'https://api.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ecs: '0bc8203a7aaa8af1456238a94c0d45c48fd46141',
    mysql: '8.0.33',
    redis: '6.0',
  },
  internalEndpoints: {
    rdb: 'mysql-dk-2416.development.local',
    redis: 'redis://redis-dk-2416.development.local',
  },
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',
    'subnet-0d07831c8fc073511',
    'subnet-033491d41490494b6',
  ],
  region: 'us-west-2',
  s3: {
    dreamkast: {
      name: 'dreamkast-dev-bucket',
      region: 'us-west-2',
    },
  },
  secretManager: {
    dk: 'dreamkast/reviewapp-env-yGJKrj',
    railsApp: 'dreamkast/rails-app-secret-SqidNC',
  },
  sentry: {
    dsn: 'TODO',
  },
  serviceDiscovery: {
    mysql: 'srv-cj2it4h62z4ksqr2',
    redis: 'srv-ppwqpomjqec4rxv2',
  },
  sqs: {
    fifo: 'dreamkast-stg-fifo-queue',
  },
  targetGroupArn: {
    dk: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2416/7e6ba9bdc2a2eb6b',
  },
}
