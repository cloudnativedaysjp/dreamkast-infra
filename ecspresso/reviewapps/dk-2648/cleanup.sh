#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2648-harvestjob &&   aws events remove-targets --rule dk-2648-harvestjob --ids dk-2648-harvestjob &&   aws events delete-rule --name dk-2648-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2648-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2648-harvestjob:1
aws servicediscovery get-service --id srv-sbh2jlunzgyheq65 &&   aws servicediscovery delete-service --id srv-sbh2jlunzgyheq65
aws servicediscovery get-service --id srv-4fcqdjdibbldwtqn &&   aws servicediscovery delete-service --id srv-4fcqdjdibbldwtqn
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/67bb81bbc44fcd24 &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/67bb81bbc44fcd24
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2648/6ec87966b6b825e4 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2648/6ec87966b6b825e4
:
