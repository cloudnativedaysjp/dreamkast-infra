#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2463-harvestjob &&   aws events delete-rule --name dk-2463-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2463-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2463-harvestjob
aws servicediscovery get-service --id srv-oyevxiutd5h7n4dh &&   aws servicediscovery delete-service --id srv-oyevxiutd5h7n4dh
aws servicediscovery get-service --id srv-aaisw3dwgqh25mkn &&   aws servicediscovery delete-service --id srv-aaisw3dwgqh25mkn
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/1e490cf07832e5ce &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/1e490cf07832e5ce
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2463/888c3a0990ba5dd2 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2463/888c3a0990ba5dd2
: