local dreamkast_weaver = import '../../../base/dreamkast-weaver.libsonnet';
local const = import '../const.libsonnet';

dreamkast_weaver.serviceDef(
  region=const.region,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-0af84e950ec9eb4f4',  // dreamkast-dev-ecs-dreamkast-weaver
  targetGroupArn=const.targetGroupArn.dkWeaver,
)
