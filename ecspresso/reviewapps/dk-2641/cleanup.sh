#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2641-harvestjob &&   aws events remove-targets --rule dk-2641-harvestjob --ids dk-2641-harvestjob &&   aws events delete-rule --name dk-2641-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2641-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2641-harvestjob:1
aws servicediscovery get-service --id srv-t6oinqva7zsug7dp &&   aws servicediscovery delete-service --id srv-t6oinqva7zsug7dp
aws servicediscovery get-service --id srv-ei2uzm2feaq5xtcx &&   aws servicediscovery delete-service --id srv-ei2uzm2feaq5xtcx
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/048baf1b6252bd00 &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/048baf1b6252bd00
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2641/d321a1995584cd3a &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2641/d321a1995584cd3a
:
