local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  role: const.taskTargetRoleName,
  rules: [
    {
      name: 'post-registration-status',
      scheduleExpression: 'cron(0 1 * * ? *)',
      taskDefinition: 'dreamkast-prod-post-registration',
      launch_type: 'FARGATE',
      platform_version: 'LATEST',
      network_configuration: {
        aws_vpc_configuration: {
          subnets: const.publicSubnetIDs,
          security_groups: [
            'sg-005b97d49a4b8431e',  // dreamkast-prod-ecs-task-registration
          ],
          assign_public_ip: 'ENABLED',
        },
      },
    },
  ],
}
