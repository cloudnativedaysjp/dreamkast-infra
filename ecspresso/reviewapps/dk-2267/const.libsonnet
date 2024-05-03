{
  "PR_NAME": "dk-2267",
  "externalEndpoints": {
    "dkApi": "https://api.dev.cloudnativedays.jp",
    "dkWeaver": "https://dkw.dev.cloudnativedays.jp"
  },
  "imageTags": {
    "dreamkast_ecs": "0daf47119aee38be8278342fcc2d5f497a32f903",
    "mysql": "8.0.33",
    "redis": "6.0"
  },
  "internalEndpoints": {
    "rdb": "mysql-dk-2267.development.local",
    "redis": "redis://redis-dk-2267.development.local"
  },
  "privateSubnetIDs": [
    "subnet-05d0a81dafd9409f9",
    "subnet-042770b2f29661e8e",
    "subnet-0d95068828df7cc3e"
  ],
  "publicSubnetIDs": [
    "subnet-00709135a42bf907e",
    "subnet-0d07831c8fc073511",
    "subnet-033491d41490494b6"
  ],
  "region": "us-west-2",
  "s3": {
    "dreamkast": {
      "name": "dreamkast-dev-bucket",
      "region": "us-west-2"
    }
  },
  "secretManager": {
    "dk": "dreamkast/reviewapp-env-yGJKrj",
    "railsApp": "dreamkast/rails-app-secret-SqidNC"
  },
  "sentry": {
    "dsn": "TODO"
  },
  "serviceDiscovery": {
    "mysql": "srv-oqkipfbr4ziqkm3m",
    "redis": "srv-jmaafqsyirfxzub3"
  },
  "sqs": {
    "fifo": "dreamkast-stg-fifo-queue"
  },
  "targetGroupArn": {
    "dk": "arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-dev-dk-2267-dreamkast/2cf1b9eaf03aa206"
  }
}
