local pushgateway = import '../../base/pushgateway.libsonnet';
local const = import '../const.libsonnet';

pushgateway.taskDef(
  family='dreamkast-stg-pushgateway',
  taskRoleName='dreamkast-dev-ecs-pushgateway',
  executionRoleName=const.executionRoleName,
  imageTag=const.imageTags.pushgateway,

  region=const.region,

  enableLogging=false,
)
