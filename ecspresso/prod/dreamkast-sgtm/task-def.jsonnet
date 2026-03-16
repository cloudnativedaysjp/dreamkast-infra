local sgtm = import '../../base/sgtm.libsonnet';
local const = import '../const.libsonnet';

sgtm.taskDef(
  family='dreamkast-prod-sgtm',
  taskRoleName='dreamkast-prod-ecs-sgtm',
  executionRoleName=const.executionRoleName,
  region=const.region,
  imageTag=const.imageTags.sgtm,
  sgtmSecretManagerName=const.secretManager.sgtm,
  enableLogging=true,
)
