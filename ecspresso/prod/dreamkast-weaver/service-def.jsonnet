local dreamkast_weaver = import '../../base/dreamkast-weaver.libsonnet';
local const = import '../const.libsonnet';

local replicas = import './vars/replicas.json';

dreamkast_weaver.serviceDef(
  region=const.region,
  replicas=replicas,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-09ff59684c29f4397',  // dreamkast-prod-ecs-dreamkast-weaver
  targetGroupArn='arn:aws:elasticloadbalancing:ap-northeast-1:607167088920:targetgroup/dreamkast-production-weaver/8dfeecc4201243e9',
)
