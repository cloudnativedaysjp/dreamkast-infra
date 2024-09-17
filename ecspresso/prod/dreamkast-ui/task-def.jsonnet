local dreamkast_ui = import '../../base/dreamkast-ui.libsonnet';
local const = import '../const.libsonnet';

dreamkast_ui.taskDef(
  family='dreamkast-prod-ui',
  taskRoleName='dreamkast-prod-ecs-dreamkast-ui',
  imageTag=const.imageTags.dreamkast_ui,

  region=const.region,
  dkEndpoint=const.externalEndpoints.dk,
  dkWeaverEndpoint=const.externalEndpoints.dkWeaver,

  dkUiSecretManagerName=const.secretManager.dkUi,

  enableLogging=true,
)
