local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  role: const.taskTargetRoleName,
  rules: [
    {
      name: 'dk-2450-harvestjob',
      scheduleExpression: 'cron(*/3 * * * ? *)',
      taskDefinition: 'dreamkast-dev-dk-2450-harvestjob',
      launch_type: 'FARGATE',
      platform_version: 'LATEST',
      network_configuration: {
        aws_vpc_configuration: {
          subnets: const.publicSubnetIDs,
          security_groups: [
            'sg-05592a72e569c245b',  // dreamkast-dev-ecs-harvestjob
          ],
          assign_public_ip: 'ENABLED',
        },
      },
    },
  ],
}
