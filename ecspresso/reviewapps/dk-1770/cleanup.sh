#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery get-service --id srv-exagg5375pjksawt &>/dev/null && aws servicediscovery delete-service --id srv-exagg5375pjksawt
aws servicediscovery get-service --id srv-43ymgkoza3aq3g5u &>/dev/null && aws servicediscovery delete-service --id srv-43ymgkoza3aq3g5u
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/cc2845e38236e868 &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/cc2845e38236e868
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-1770/3b0dd92ae6214268 &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-1770/3b0dd92ae6214268
:
