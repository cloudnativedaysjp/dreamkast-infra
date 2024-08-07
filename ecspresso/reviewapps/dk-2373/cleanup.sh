#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery delete-service --id srv-p6wwokow55x4ec53
aws servicediscovery delete-service --id srv-26rc7tp2lj53ioyo
aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/2715193e354b3d9e
aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2373/6eb35300d4885036
