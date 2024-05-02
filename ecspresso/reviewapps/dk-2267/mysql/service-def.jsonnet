local redis = import '../../../base/mysql.libsonnet';
local const = import '../const.libsonnet';

redis.serviceDef(
  region=const.region,
  subnetIDs=const.privateSubnetIDs,
  securityGroupID='TODO',  // dreamkast-dev-ecs-dreamkast-mysql
  serviceDiscoveryID=const.serviceDiscovery.mysql,
)
