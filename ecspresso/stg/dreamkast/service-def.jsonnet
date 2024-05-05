local dreamkast_dk = import '../../base/dreamkast.libsonnet';
local const = import '../const.libsonnet';

dreamkast_dk.serviceDef(
  region=const.region,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-00e734fea020b954d',  // dreamkast-dev-ecs-dreamkast
  serviceDiscoveryID=const.serviceDiscovery.dk,
  targetGroupArn='arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-staging-dk/22274a4b702fe524',
)
