local redis = import '../../../base/redis.libsonnet';
local const = import '../const.libsonnet';

redis.taskDef(
  family='dreamkast-stg-%s-mysql' % [const.PR_NAME],
  taskRoleName='dreamkast-dev-ecs-mysql',
  imageTag=const.imageTags.mysql,

  region=const.region,

  enableLogging=false,
)
