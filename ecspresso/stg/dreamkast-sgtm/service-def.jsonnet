local sgtm = import '../../base/sgtm.libsonnet';
local const = import '../const.libsonnet';

local replicas = import './vars/replicas.json';

sgtm.serviceDef(
  region=const.region,
  replicas=replicas,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-03bf729935531a5e8',  // dreamkast-dev-ecs-sgtm
  targetGroupArn='arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-staging-sgtm/f30df6eefe83d869',
)
