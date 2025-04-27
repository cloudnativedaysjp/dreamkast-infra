{
  PR_NAME: 'ui-554',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dk: 'https://development.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ui: 'commit-8d3a6231e5afc191c54ac4297889f6696e765830',
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
    dkUi: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-ui-554/d6e3df0719c28909',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
