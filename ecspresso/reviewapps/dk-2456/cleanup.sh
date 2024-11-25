#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2456-harvestjob &&   aws events delete-rule --name dk-2456-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2456-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2456-harvestjob
aws servicediscovery get-service --id srv-xvtk2oj77ak7ggzl &&   aws servicediscovery delete-service --id srv-xvtk2oj77ak7ggzl
aws servicediscovery get-service --id srv-c7kzh52le4mparwi &&   aws servicediscovery delete-service --id srv-c7kzh52le4mparwi
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/f1fdf882323a2f0a &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/f1fdf882323a2f0a
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2456/058d86df2e492c82 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2456/058d86df2e492c82
:
