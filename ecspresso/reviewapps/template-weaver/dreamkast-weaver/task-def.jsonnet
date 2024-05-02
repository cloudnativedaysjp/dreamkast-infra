local dreamkast_weaver = import '../../../base/dreamkast-weaver.libsonnet';
local const = import '../const.libsonnet';

dreamkast_weaver.taskDef(
  family='dreamkast-dev-%s-ui' % [const.PR_NAME],
  taskRoleName='dreamkast-dev-ecs-dreamkast-weaver',
  imageTag=const.imageTags.dreamkast_weaver,

  region=const.region,
  dkInternalEndpoint=const.internalEndpoints.dk,
  rdbInternalEndpoint=const.internalEndpoints.rdb,

  rdsSecretManagerName=const.secretManager.rds,

  enableLogging=true,
  reviewapp=true,
)
