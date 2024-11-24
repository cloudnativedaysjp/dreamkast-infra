local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  service: 'dk-2449-redis',
  service_definition: 'service-def.jsonnet',
  task_definition: 'task-def.jsonnet',
  timeout: '10m',
}
