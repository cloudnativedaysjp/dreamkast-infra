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
      taskDefinition: 'dreamkast-stg-harvestjob',
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
