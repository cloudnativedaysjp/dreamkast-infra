local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  role: const.taskTargetRoleName,
  rules: [
    {
      name: '%s-harvestjob' % [const.PR_NAME],
      scheduleExpression: 'cron(*/3 * * * ? *)',
      taskDefinition: 'dreamkast-dev-%s-harvestjob' % [const.PR_NAME],
      launch_type: 'FARGATE',
      platform_version: 'LATEST',
      disabled: true,
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
