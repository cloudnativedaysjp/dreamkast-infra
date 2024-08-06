local dreamkast_weaver = import '../../base/dreamkast-weaver.libsonnet';
local const = import '../const.libsonnet';

local replicas = import './vars/replicas.json';

dreamkast_weaver.serviceDef(
  region=const.region,
  replicas=replicas,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-0af84e950ec9eb4f4',  // dreamkast-dev-ecs-dreamkast-weaver
  targetGroupArn='arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-staging-weaver/0b1130586fc97be0',
)
