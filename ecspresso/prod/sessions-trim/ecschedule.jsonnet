local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  role: const.taskTargetRoleName,
  rules: [
    {
      name: 'sessions-trim',
      // 03:00 JST (18:00 UTC) の低トラフィック帯に実行する。
      scheduleExpression: 'cron(0 18 * * ? *)',
      taskDefinition: 'dreamkast-prod-sessions-trim',
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
