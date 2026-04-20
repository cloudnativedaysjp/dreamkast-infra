{
  PR_NAME: 'ui-582',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dk: 'https://development.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ui: 'commit-69408e591c59e3c8c700cc91a1bee5bccb7e119f',
  },
  internalEndpoints: {},
  publicSubnetIDs: [
    'subnet-00709135a42bf907e',
    'subnet-0d07831c8fc073511',
    'subnet-033491d41490494b6',
  ],
  region: 'us-west-2',
  secretManager: {
    dkUi: 'dreamkast-ui/reviewapp-env-Cytidj',
  },
  targetGroupArn: {
    dkUi: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-ui-582/260d221cb2ee8512',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
