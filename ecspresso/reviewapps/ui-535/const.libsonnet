{
  PR_NAME: 'ui-535',
  cluster: 'dreamkast-dev',
  executionRoleName: 'dreamkast-dev-ecs-task-execution-role',
  externalEndpoints: {
    dk: 'https://development.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ui: 'c79f9c5c249497977ecd8a25a0bb605a35770330',
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
    dkUi: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-ui-535/e870e791d0463b70',
  },
  taskTargetRoleName: 'dreamkast-dev-ecs-scheduled-task-target-role',
}
