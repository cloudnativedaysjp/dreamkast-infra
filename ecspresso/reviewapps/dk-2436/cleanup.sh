#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events delete-rule --name dk-2436-harvestjob
aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2436-harvestjob
aws servicediscovery get-service --id srv-7gszoo3bc3yy5ssy &>/dev/null && aws servicediscovery delete-service --id srv-7gszoo3bc3yy5ssy
aws servicediscovery get-service --id srv-rwdwn2ueyyz63pjn &>/dev/null && aws servicediscovery delete-service --id srv-rwdwn2ueyyz63pjn
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/9d024e9b52b77a87 &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/9d024e9b52b77a87
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2436/b8fd45cb48621205 &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2436/b8fd45cb48621205
:
