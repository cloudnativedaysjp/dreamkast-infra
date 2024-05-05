{
  PR_NAME: 'ui-491',
  externalEndpoints: {
    dk: 'https://development.dev.cloudnativedays.jp',
    dkWeaver: 'https://dkw.dev.cloudnativedays.jp',
  },
  imageTags: {
    dreamkast_ui: '8cde0cf306d1bffc6f773ef9a0a889ae3fa3ceff',
  },
  internalEndpoints: {},
  privateSubnetIDs: [
    'subnet-05d0a81dafd9409f9',
    'subnet-042770b2f29661e8e',
    'subnet-0d95068828df7cc3e',
  ],
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
    dkUi: 'arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-dev-ui-491-dreamkast/df1f0c11e38654cd',
  },
}
