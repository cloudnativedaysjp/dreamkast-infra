{
  PR_NAME: 'weaver-117',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {},
  imageTags: {
    dreamkast_weaver: 'commit-e2e83293e272dc373de4b7e1fbbcc84521a6535b',
    mysql: '8.0.33',
  },
  internalEndpoints: {
    dk: 'http://dreamkast.development.local:3000',
    rdb: 'mysql-weaver-117.development.local',
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
    mysql: 'srv-l2c47iw46tpelwdm',
  },
  targetGroupArn: {
    dkWeaver: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-weaver-117/7492077d6be0ea95',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
