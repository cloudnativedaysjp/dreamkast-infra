local dreamkast_dk = import '../../../base/dreamkast.libsonnet';
local const = import '../const.libsonnet';

dreamkast_dk.serviceDef(
  region=const.region,
  subnetIDs=const.privateSubnetIDs,
  securityGroupID='sg-00e734fea020b954d',  // dreamkast-dev-ecs-dreamkast
  targetGroupArn=const.targetGroupArn.dk,
)
