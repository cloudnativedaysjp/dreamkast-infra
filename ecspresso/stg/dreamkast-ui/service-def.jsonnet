local dreamkast_ui = import '../../base/dreamkast-ui.libsonnet';
local const = import '../const.libsonnet';

dreamkast_ui.serviceDef(
  region=const.region,
  subnetIDs=const.privateSubnetIDs,
  securityGroupID='sg-026faf401f03b7bd4',  // dreamkast-dev-ecs-dreamkast-ui
  targetGroupArn='arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-staging-ui/3888d58f7fc43c56',
)
