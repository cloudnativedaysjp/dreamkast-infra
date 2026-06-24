local dreamkast_fifo_worker = import '../../../base/dreamkast-fifo-worker.libsonnet';
local const = import '../const.libsonnet';

dreamkast_fifo_worker.serviceDef(
  region=const.region,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-0140d2aeaaa5d6d07',  // dreamkast-dev-ecs-dreamkast-fifo-worker
)
