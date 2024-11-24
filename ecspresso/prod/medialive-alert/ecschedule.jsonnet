local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  role: const.taskTargetRoleName,
  rules: [
    {
      name: 'medialive-alert',
      scheduleExpression: 'cron(0 1 * * ? *)',
      taskDefinition: 'dreamkast-prod-medialive-alert',
      launch_type: 'FARGATE',
      platform_version: 'LATEST',
      network_configuration: {
        aws_vpc_configuration: {
          subnets: const.publicSubnetIDs,
          security_groups: [
            'sg-0365b63a76a7a9397',  // dreamkast-prod-ecs-medialive-alert
          ],
          assign_public_ip: 'ENABLED',
        },
      },
    },
  ],
}
