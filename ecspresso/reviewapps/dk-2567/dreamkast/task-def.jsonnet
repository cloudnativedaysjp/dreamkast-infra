local dreamkast = import '../../../base/dreamkast.libsonnet';
local const = import '../const.libsonnet';

dreamkast.taskDef(
  family='dreamkast-dev-%s-dk' % [const.PR_NAME],
  taskRoleName='dreamkast-dev-ecs-dreamkast',
  executionRoleName=const.executionRoleName,
  imageTag=const.imageTags.dreamkast_ecs,

  region=const.region,
  dkApiEndpoint=const.externalEndpoints.dkApi,
  dkWeaverEndpoint=const.externalEndpoints.dkWeaver,
  rdbInternalEndpoint=const.internalEndpoints.rdb,
  redisInternalEndpoint=const.internalEndpoints.redis,

  s3BucketName=const.s3.dreamkast.name,
  s3BucketRegion=const.s3.dreamkast.region,

  sqsFifoQueueName=const.sqs.fifo,

  sentryDsn=const.sentry.dsn,

  railsAppSecretManagerName=const.secretManager.railsApp,
  rdsSecretManagerName=const.secretManager.rds,
  dreamkastSecretManagerName=const.secretManager.dk,

  enableLogging=true,
  reviewapp=true,
)
