local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  service: '%s-dreamkast-weaver' % [const.PR_NAME],
  service_definition: 'service-def.jsonnet',
  task_definition: 'task-def.jsonnet',
  timeout: '15m',
}
