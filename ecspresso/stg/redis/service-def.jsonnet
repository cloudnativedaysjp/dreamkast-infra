local redis = import '../../base/redis.libsonnet';
local const = import '../const.libsonnet';

// 脱Redis (dreamkast#2844) により stg のアプリは Redis を参照しなくなったため 0 台にする。
// 問題が無いことを確認できたら、このサービス定義と const.libsonnet の redis 関連を削除する。
redis.serviceDef(
  region=const.region,
  replicas=0,
  subnetIDs=const.publicSubnetIDs,
  securityGroupID='sg-0ab649652e2dd6c9c',  // dreamkast-dev-ecs-redis
  serviceDiscoveryID=const.serviceDiscovery.redis,
)
