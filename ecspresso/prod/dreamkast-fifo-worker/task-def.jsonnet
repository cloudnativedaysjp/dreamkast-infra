local dreamkast_fifo_worker = import '../../base/dreamkast-fifo-worker.libsonnet';
local const = import '../const.libsonnet';
local otelcol_config = importstr './files/otelcol-config.yaml';

dreamkast_fifo_worker.taskDef(
  family='dreamkast-prod-fifo-worker',
  taskRoleName='dreamkast-prod-ecs-dreamkast-fifo-worker',
  executionRoleName=const.executionRoleName,
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

  enableOtelcolSidecar=true,
  mackerelSecretManagerName=const.secretManager.mackerel,
  otelcolConfig=otelcol_config,
)
