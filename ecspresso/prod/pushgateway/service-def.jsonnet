local redis = import '../../base/pushgateway.libsonnet';
local const = import '../const.libsonnet';

redis.serviceDef(
  region=const.region,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID=TODO,  // dreamkast-prod-ecs-pushgateway
  serviceDiscoveryID=const.serviceDiscovery.pushgateway,
)
