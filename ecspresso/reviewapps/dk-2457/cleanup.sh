#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2457-harvestjob &&   aws events delete-rule --name dk-2457-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2457-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2457-harvestjob
aws servicediscovery get-service --id srv-bmtr5gvsv3ku2wf5 &&   aws servicediscovery delete-service --id srv-bmtr5gvsv3ku2wf5
aws servicediscovery get-service --id srv-3oet75vylu2ighqk &&   aws servicediscovery delete-service --id srv-3oet75vylu2ighqk
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/ab5d2fe67c00e848 &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/ab5d2fe67c00e848
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2457/7a3f43678dd24042 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2457/7a3f43678dd24042
:
