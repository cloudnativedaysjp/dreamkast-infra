local pushgateway = import '../../base/pushgateway.libsonnet';
local const = import '../const.libsonnet';

pushgateway.taskDef(
  family='dreamkast-prod-pushgateway',
  taskRoleName='dreamkast-prod-ecs-pushgateway',
  executionRoleName=const.executionRoleName,
  imageTag=const.imageTags.pushgateway,

  region=const.region,

  enableLogging=false,
)
