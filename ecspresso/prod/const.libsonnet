{
  externalEndpoints: {
    dk: 'https://event.cloudnativedays.jp',
    dkApi: 'https://api.cloudnativedays.jp',
    dkWeaver: 'https://dkw.cloudnativedays.jp',
    loki: error 'TODO',
  },
  imageTags: {
    dreamkast_ecs: 'v4.10.0',
    dreamkast_ui: 'v2.11.4',
    dreamkast_weaver: 'v0.0.3',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.production.local',
    rdb: 'dreamkast-prod-rds.c6eparu1hmbv.ap-northeast-1.rds.amazonaws.com',
    redis: 'redis://dreamkast-prod-redis.bp6loy.ng.0001.apne1.cache.amazonaws.com:6379',
  },
  publicSubnetIDs: [
    'subnet-0def25751622d2c79',
    'subnet-0a772652fcbd0baaa',
    'subnet-04ba7895220a7ebc7',
  ],
  region: 'ap-northeast-1',
  s3: {
    dreamkast: {
      name: 'dreamkast-prod-bucket',
      region: 'ap-northeast-1',
    },
  },
  secretManager: {
    dk: 'dreamkast/production-env',
    dkUi: 'dreamkast-ui/production-env-OEnUAF',
    mackerel: error 'TODO',
    railsApp: 'dreamkast/rails-app-secret',
    rds: 'dreamkast-prod-rds-secret',
  },
  sentry: {
    dsn: 'https://ec7eb42486bea4e950a48ef1c943510c@sentry.cloudnativedays.jp/2',
  },
  serviceDiscovery: {
    dk: 'srv-x5wza5r7otdcwmt3',
  },
  sqs: {
    fifo: 'dreamkast-prod-fifo-queue',
    mail: 'dreamkast-prod-mail-queue',
  },
}
