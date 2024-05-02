local const = import './const.libsonnet';

{
  serviceDef(
    region,
    replicas,
    subnetIDs,
    securityGroupID,
    serviceDiscoveryID='',
  ):: {
    deploymentConfiguration: {
      deploymentCircuitBreaker: {
        enable: false,
        rollback: false,
      },
      maximumPercent: 200,
      minimumHealthyPercent: 100,
    },
    desiredCount: replicas,
    enableECSManagedTags: true,
    enableExecuteCommand: true,
    launchType: 'FARGATE',
    loadBalancers: [],
    networkConfiguration: {
      awsvpcConfiguration: {
        assignPublicIp: 'DISABLED',
        securityGroups: [securityGroupID],
        subnets: subnetIDs,
      },
    },
    placementConstraints: [],
    placementStrategy: [],
    platformVersion: 'LATEST',
    propagateTags: 'NONE',
    schedulingStrategy: 'REPLICA',
    serviceRegistries: if serviceDiscoveryID != '' then [
      {
        registryArn: 'arn:aws:servicediscovery:%s:%s:service/%s' % [region, const.accountID, serviceDiscoveryID],
      },
    ] else [],
  },
}
