local mysql = import '../../../base/mysql.libsonnet';
local const = import '../const.libsonnet';

mysql.taskDef(
  family='dreamkast-stg-%s-mysql' % [const.PR_NAME],
  taskRoleName='dreamkast-dev-ecs-mysql',
  imageTag=const.imageTags.mysql,

  region=const.region,

  enableLogging=true,
)
