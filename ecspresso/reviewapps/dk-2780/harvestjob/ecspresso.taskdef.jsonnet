local const = import '../const.libsonnet';
{
  region: const.region,
  cluster: const.cluster,
  task_definition: 'task-def.jsonnet',
  timeout: '5m',
}
