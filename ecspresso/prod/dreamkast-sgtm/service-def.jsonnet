local sgtm = import '../../base/sgtm.libsonnet';
local const = import '../const.libsonnet';

local replicas = import './vars/replicas.json';

sgtm.serviceDef(
  region=const.region,
  replicas=replicas,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-0bc46a23214bf009b',
  targetGroupArn='arn:aws:elasticloadbalancing:ap-northeast-1:607167088920:targetgroup/dreamkast-production-sgtm/6c130d93521d9fb6',
)
