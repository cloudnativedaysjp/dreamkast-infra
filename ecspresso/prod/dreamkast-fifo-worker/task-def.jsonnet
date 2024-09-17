local dreamkast_fifo_worker = import '../../base/dreamkast-fifo-worker.libsonnet';
local const = import '../const.libsonnet';

dreamkast_fifo_worker.taskDef(
  family='dreamkast-prod-fifo-worker',
  taskRoleName='dreamkast-prod-ecs-dreamkast-fifo-worker',
  imageTag=const.imageTags.dreamkast_ecs,

  region=const.region,
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
)
