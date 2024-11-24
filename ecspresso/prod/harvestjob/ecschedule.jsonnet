local const = import '../const.libsonnet';
local disabled = import './vars/disabled.json';

{
  region: const.region,
  cluster: const.cluster,
  role: const.taskTargetRoleName,
  rules: [
    {
      name: 'harvestjob',
      disabled: disabled,
      scheduleExpression: 'cron(*/3 * * * ? *)',
      taskDefinition: 'dreamkast-prod-harvestjob',
      launch_type: 'FARGATE',
      platform_version: 'LATEST',
      network_configuration: {
        aws_vpc_configuration: {
          subnets: const.publicSubnetIDs,
          security_groups: [
            'sg-0f10333f7af41d190',  // dreamkast-prod-ecs-harvestjob
          ],
          assign_public_ip: 'ENABLED',
        },
      },
    },
  ],
}
