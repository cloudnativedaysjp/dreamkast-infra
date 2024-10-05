{
  PR_NAME: 'ui-519',
  externalEndpoints: {
    dk: 'https://development.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ui: '38d9eac692413339fd4fa9835cea649f66fbb57f',
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
    dkUi: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-ui-519/c3a0b473227d4962',
  },
}
