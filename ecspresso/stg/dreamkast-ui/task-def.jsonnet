local dreamkast_ui = import '../../base/dreamkast-ui.libsonnet';
local const = import '../const.libsonnet';
local otelcol_config = importstr './files/otelcol-config.yaml';

dreamkast_ui.taskDef(
  family='dreamkast-stg-ui',
  taskRoleName='dreamkast-dev-ecs-dreamkast-ui',
  executionRoleName=const.executionRoleName,
  imageTag=const.imageTags.dreamkast_ui,

  region=const.region,
  dkEndpoint=const.externalEndpoints.dk,
  dkWeaverEndpoint=const.externalEndpoints.dkWeaver,

  dkUiSecretManagerName=const.secretManager.dkUi,

  enableLogging=true,

  enableOtelcolSidecar=false,
  mackerelSecretManagerName=const.secretManager.mackerel,
  otelcolConfig=otelcol_config,
)
