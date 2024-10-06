#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery get-service --id srv-25ojxou2u5pmqpem &>/dev/null && aws servicediscovery delete-service --id srv-25ojxou2u5pmqpem
aws servicediscovery get-service --id srv-2fj3zvwg7zinudux &>/dev/null && aws servicediscovery delete-service --id srv-2fj3zvwg7zinudux
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/f125dcbaa8d41b6a &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/f125dcbaa8d41b6a
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2413/e80be102de4f869d &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2413/e80be102de4f869d
:
