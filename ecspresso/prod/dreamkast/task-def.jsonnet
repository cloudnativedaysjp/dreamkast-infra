local dreamkast = import '../../base/dreamkast.libsonnet';
local const = import '../const.libsonnet';
local otelcol_config = importstr './files/otelcol-config.yaml';

dreamkast.taskDef(
  family='dreamkast-prod-dk',
  cpu=1024,
  memory=2048,
  taskRoleName='dreamkast-prod-ecs-dreamkast',
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

  enableLogging=false,

  enableLokiLogging=true,
  lokiEndpoint=const.externalEndpoints.loki,

  enableOtelcolSidecar=true,
  mackerelSecretManagerName=const.secretManager.mackerel,
  otelcolConfig=otelcol_config,
)
