#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2555-harvestjob &&   aws events remove-targets --rule dk-2555-harvestjob --ids dk-2555-harvestjob &&   aws events delete-rule --name dk-2555-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2555-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2555-harvestjob:1
aws servicediscovery get-service --id srv-dai5bmebhxom7cri &&   aws servicediscovery delete-service --id srv-dai5bmebhxom7cri
aws servicediscovery get-service --id srv-pqzrpzhw6dzsmvpo &&   aws servicediscovery delete-service --id srv-pqzrpzhw6dzsmvpo
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/3884851ac861d7bc &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/3884851ac861d7bc
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2555/7b1de1bee8409014 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2555/7b1de1bee8409014
:
