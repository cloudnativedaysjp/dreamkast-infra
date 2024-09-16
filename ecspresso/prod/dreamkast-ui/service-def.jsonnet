local dreamkast_ui = import '../../base/dreamkast-ui.libsonnet';
local const = import '../const.libsonnet';

local replicas = import './vars/replicas.json';

dreamkast_ui.serviceDef(
  region=const.region,
  replicas=replicas,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-01892d609000f8e25',  // dreamkast-prod-ecs-dreamkast-ui
  targetGroupArn='arn:aws:elasticloadbalancing:ap-northeast-1:607167088920:targetgroup/dreamkast-production-ui/dc24628d7181c60d',
)
