#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2675-harvestjob &&   aws events remove-targets --rule dk-2675-harvestjob --ids dk-2675-harvestjob &&   aws events delete-rule --name dk-2675-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2675-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2675-harvestjob:1
aws servicediscovery get-service --id srv-aeqd3sb3mmtwrk3h &&   aws servicediscovery delete-service --id srv-aeqd3sb3mmtwrk3h
aws servicediscovery get-service --id srv-ido6ax3pbmgcurwc &&   aws servicediscovery delete-service --id srv-ido6ax3pbmgcurwc
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/1f2f97bb86196d4b &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/1f2f97bb86196d4b
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2675/3a60bdef00d05685 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2675/3a60bdef00d05685
:
