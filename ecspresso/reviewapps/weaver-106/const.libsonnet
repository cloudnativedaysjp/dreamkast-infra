{
  PR_NAME: 'weaver-106',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {},
  imageTags: {
    dreamkast_weaver: 'cd5d7387fb2213d060e8cca5fb4d3491d1eb9dd1',
    mysql: '8.0.33',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.development.local:3000',
    rdb: 'mysql-weaver-106.development.local',
  },
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',
    'subnet-0d07831c8fc073511',
    'subnet-033491d41490494b6',
  ],
  region: 'us-west-2',
  secretManager: {
    rds: 'dreamkast-stg-rds-secret-0dsVhM',
  },
  serviceDiscovery: {
    mysql: 'srv-n3o7df5linw7hhoz',
  },
  targetGroupArn: {
    dkWeaver: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-weaver-106/42279a3e932b23f3',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
