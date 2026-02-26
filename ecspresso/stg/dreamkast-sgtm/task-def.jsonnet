local sgtm = import '../../base/sgtm.libsonnet';
local const = import '../const.libsonnet';

sgtm.taskDef(
  family='dreamkast-stg-sgtm',
  taskRoleName='dreamkast-dev-ecs-sgtm',
  executionRoleName=const.executionRoleName,
  region=const.region,
  imageTag=const.imageTags.sgtm,
  containerConfig=const.sgtm.containerConfig,
  enableLogging=true,
)
