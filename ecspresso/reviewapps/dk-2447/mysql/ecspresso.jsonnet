local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  service: 'dk-2447-mysql',
  service_definition: 'service-def.jsonnet',
  task_definition: 'task-def.jsonnet',
  timeout: '10m',
}
