#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events delete-rule --name dk-2449-harvestjob
aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2449-harvestjob
aws servicediscovery get-service --id srv-x6bksinwn55vxn5n &>/dev/null && aws servicediscovery delete-service --id srv-x6bksinwn55vxn5n
aws servicediscovery get-service --id srv-n25xqwmebz7ve5ou &>/dev/null && aws servicediscovery delete-service --id srv-n25xqwmebz7ve5ou
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/33c04afba7087f80 &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/33c04afba7087f80
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2449/eef046ce6d6d3e3f &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2449/eef046ce6d6d3e3f
:
