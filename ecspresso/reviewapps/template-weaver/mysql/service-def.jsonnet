local redis = import '../../../base/mysql.libsonnet';
local const = import '../const.libsonnet';

redis.serviceDef(
  region=const.region,
  subnetIDs=const.privateSubnetIDs,
  securityGroupID='sg-0e0029eb49f4d0455',  // dreamkast-dev-ecs-mysql
  serviceDiscoveryID=const.serviceDiscovery.mysql,
)
