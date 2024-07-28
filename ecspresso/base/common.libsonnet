local const = import './const.libsonnet';

{
  # https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/service_definition_parameters.html
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
        assignPublicIp: 'ENABLED',
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
