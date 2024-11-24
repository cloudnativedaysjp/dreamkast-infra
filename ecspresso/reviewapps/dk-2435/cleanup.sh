#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events delete-rule --name dk-2435-harvestjob ||:
aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2435-harvestjob ||:
aws servicediscovery get-service --id srv-45pwi75cd2cg2ppk &>/dev/null && aws servicediscovery delete-service --id srv-45pwi75cd2cg2ppk
aws servicediscovery get-service --id srv-x4xe5i3tpj5kqlto &>/dev/null && aws servicediscovery delete-service --id srv-x4xe5i3tpj5kqlto
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/e25bbfc55c0f6a85 &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/e25bbfc55c0f6a85
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2435/95c337a415b1e2d3 &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2435/95c337a415b1e2d3
:
