#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events delete-rule --name dk-2448-harvestjob ||:
aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2448-harvestjob ||:
aws servicediscovery get-service --id srv-c5goft3lat4domzj &>/dev/null && aws servicediscovery delete-service --id srv-c5goft3lat4domzj
aws servicediscovery get-service --id srv-vhcfpf7pt2jyhp77 &>/dev/null && aws servicediscovery delete-service --id srv-vhcfpf7pt2jyhp77
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/56ddb4931ff7b2bb &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/56ddb4931ff7b2bb
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2448/767366364d1f390f &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2448/767366364d1f390f
:
