local dreamkast_weaver = import '../../base/dreamkast-weaver.libsonnet';
local const = import '../const.libsonnet';

dreamkast_weaver.taskDef(
  family='dreamkast-stg-weaver',
  taskRoleName='dreamkast-dev-ecs-dreamkast-weaver',
  executionRoleName=const.executionRoleName,
  imageTag=const.imageTags.dreamkast_weaver,

  region=const.region,
  dkInternalEndpoint=const.internalEndpoints.dk,
  rdbInternalEndpoint=const.internalEndpoints.rdb,
  promPushgatewayEndpoint=const.internalEndpoints.pushgateway

  rdsSecretManagerName=const.secretManager.rds,

  enableLogging=true,
)
