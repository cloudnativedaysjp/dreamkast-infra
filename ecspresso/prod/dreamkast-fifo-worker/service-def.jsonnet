local dreamkast_fifo_worker = import '../../base/dreamkast-fifo-worker.libsonnet';
local const = import '../const.libsonnet';

dreamkast_fifo_worker.serviceDef(
  region=const.region,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-0f56fd361d7bdbd40',  // dreamkast-prod-ecs-dreamkast-fifo-worker
)
