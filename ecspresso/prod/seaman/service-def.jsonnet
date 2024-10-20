local common = import '../../base/common.libsonnet';
local const = import '../const.libsonnet';

common.serviceDef(
  region=const.region,
  replicas=1,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-05e71d949ddbf1086',  // dreamkast-prod-applications-without-listening-any-ports
)
