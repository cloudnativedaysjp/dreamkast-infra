#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery get-service --id srv-vg4ikqj7sfuh33zp &>/dev/null && aws servicediscovery delete-service --id srv-vg4ikqj7sfuh33zp
aws servicediscovery get-service --id srv-j2ng3nkddb2zqok3 &>/dev/null && aws servicediscovery delete-service --id srv-j2ng3nkddb2zqok3
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/5b36d90ce6272e78 &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/5b36d90ce6272e78
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2410/1b31c849b290e4cc &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2410/1b31c849b290e4cc
:
