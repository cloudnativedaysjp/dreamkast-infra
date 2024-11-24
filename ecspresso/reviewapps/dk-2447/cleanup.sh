#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events delete-rule --name dk-2447-harvestjob ||:
aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2447-harvestjob ||:
aws servicediscovery get-service --id srv-p233zntmdxguifla &>/dev/null && aws servicediscovery delete-service --id srv-p233zntmdxguifla
aws servicediscovery get-service --id srv-xolbd2ab4vyz5jyc &>/dev/null && aws servicediscovery delete-service --id srv-xolbd2ab4vyz5jyc
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/5c3bae94bb3a94cd &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/5c3bae94bb3a94cd
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2447/c6badb45219e4e50 &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2447/c6badb45219e4e50
:
