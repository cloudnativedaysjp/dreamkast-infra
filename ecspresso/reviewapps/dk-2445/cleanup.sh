#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events delete-rule --name dk-2445-harvestjob
aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2445-harvestjob
aws servicediscovery get-service --id srv-s3oyoi7hl3c5dsab &>/dev/null && aws servicediscovery delete-service --id srv-s3oyoi7hl3c5dsab
aws servicediscovery get-service --id srv-6afgopoy3yvjzhld &>/dev/null && aws servicediscovery delete-service --id srv-6afgopoy3yvjzhld
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/f3279a80d5d6108e &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/f3279a80d5d6108e
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2445/f9d4a2f3bd520442 &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2445/f9d4a2f3bd520442
:
