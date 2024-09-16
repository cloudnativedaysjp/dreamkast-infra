local dreamkast_dk = import '../../base/dreamkast.libsonnet';
local const = import '../const.libsonnet';

local replicas = import './vars/replicas.json';

dreamkast_dk.serviceDef(
  region=const.region,
  replicas=replicas,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-09a1ab9d54670c89d',  // dreamkast-prod-ecs-dreamkast
  serviceDiscoveryID=const.serviceDiscovery.dk,
  targetGroupArn='arn:aws:elasticloadbalancing:ap-northeast-1:607167088920:targetgroup/dreamkast-production-dk/daf9f63b2140097f',
)
