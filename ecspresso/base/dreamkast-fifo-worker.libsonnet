local common = import './common.libsonnet';
local const = import './const.libsonnet';

{
  serviceDef(
    region,
    replicas=1,
    subnetIDs=[],
    securityGroupID,
  )::
    common.serviceDef(
      region,
      replicas,
      subnetIDs,
      securityGroupID,
    ),

  // https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
  taskDef(
    family,
    taskRoleName,
    imageTag,
    region,
    rdbInternalEndpoint,
    redisInternalEndpoint,
    s3BucketName,
    s3BucketRegion,
    sqsFifoQueueName,
    sentryDsn,
    railsAppSecretManagerName,
    rdsSecretManagerName,
    dreamkastSecretManagerName,
    enableLogging=false,
    reviewapp=false,
  ):: {
    executionRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, const.executionRoleName],
    taskRoleArn: 'arn:aws:iam::%s:role/%s' % [const.accountID, taskRoleName],
    family: family,
    cpu: '256',
    memory: '512',
    networkMode: 'awsvpc',
    requiresCompatibilities: ['FARGATE'],
    volumes: [],
    containerDefinitions: [
      {
        name: 'dreamkast-fifo-worker',
        image: '%s.dkr.ecr.%s.amazonaws.com/dreamkast-ecs:%s' % [const.accountID, region, imageTag],
        entryPoint: ['bundle'],
        command: ['exec', 'rake', 'aws_sqs:fifo_job'],
        cpu: 256,
        memoryReservation: 512,
        essential: true,
        environment: [
          {
            name: 'RAILS_ENV',
            value: 'production',
          },
          {
            name: 'MYSQL_HOST',
            value: rdbInternalEndpoint,
          },
          {
            name: 'MYSQL_DATABASE',
            value: 'dreamkast',
          },
          {
            name: 'REDIS_URL',
            value: redisInternalEndpoint,
          },
          {
            name: 'SENTRY_DSN',
            value: sentryDsn,
          },
          {
            name: 'OTEL_SERVICE_NAME',
            value: 'dreamkast-fifo-worker',
          },
          {
            name: 'S3_BUCKET',
            value: s3BucketName,
          },
          {
            name: 'S3_REGION',
            value: s3BucketRegion,
          },
          {
            name: 'AWS_REGION',
            value: region,
          },
          {
            name: 'SQS_FIFO_QUEUE_URL',
            value: 'https://sqs.%s.amazonaws.com/%s/%s.fifo' % [region, const.accountID, sqsFifoQueueName],
          },
          {
            name: 'DREAMKAST_NAMESPACE',
            value: if family == 'dreamkast-prd-ui' then 'dreamkast'
            else if family == 'dreamkast-stg-ui' then 'dreamkast-staging'
            else family,
          },
        ],
        secrets: [
          // from rails-app-secret Secret
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s' % [region, const.accountID, railsAppSecretManagerName],
            name: 'RAILS_MASTER_KEY',
          },
          // from dreamkast Secret
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:AUTH0_CLIENT_ID::' % [region, const.accountID, dreamkastSecretManagerName],
            name: 'AUTH0_CLIENT_ID',
          },
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:AUTH0_CLIENT_SECRET::' % [region, const.accountID, dreamkastSecretManagerName],
            name: 'AUTH0_CLIENT_SECRET',
          },
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:AUTH0_DOMAIN::' % [region, const.accountID, dreamkastSecretManagerName],
            name: 'AUTH0_DOMAIN',
          },
        ] + if reviewapp == false then [
          // from rds-secret Secret
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:username::' % [region, const.accountID, rdsSecretManagerName],
            name: 'MYSQL_USER',
          },
          {
            valueFrom: 'arn:aws:secretsmanager:%s:%s:secret:%s:password::' % [region, const.accountID, rdsSecretManagerName],
            name: 'MYSQL_PASSWORD',
          },
        ] else [],

        portMappings: [],
        links: [],
        mountPoints: [],
        volumesFrom: [],
        dependsOn: [],
      } + if enableLogging then {
        logConfiguration: {
          logDriver: 'awslogs',
          options: {
            'awslogs-group': family,
            'awslogs-create-group': 'true',
            'awslogs-region': region,
            'awslogs-stream-prefix': 'dreamkast-fifo-worker',
          },
        },
      } else {},
    ],
  },
}
