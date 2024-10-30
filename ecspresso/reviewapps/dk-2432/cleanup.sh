#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery get-service --id srv-ace5kliwicmuyqt5 &>/dev/null && aws servicediscovery delete-service --id srv-ace5kliwicmuyqt5
aws servicediscovery get-service --id srv-5qjsvss5ubcd7c5r &>/dev/null && aws servicediscovery delete-service --id srv-5qjsvss5ubcd7c5r
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/a5e2e81918d8b628 &>/dev/null && aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/a5e2e81918d8b628
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2432/f19ebae0569c1136 &>/dev/null && aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2432/f19ebae0569c1136
:
