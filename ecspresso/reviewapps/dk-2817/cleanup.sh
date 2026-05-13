#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2817-harvestjob &&   aws events remove-targets --rule dk-2817-harvestjob --ids dk-2817-harvestjob &&   aws events delete-rule --name dk-2817-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2817-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2817-harvestjob:1
aws servicediscovery get-service --id srv-i55qfkcd2dkl3qvr &&   aws servicediscovery delete-service --id srv-i55qfkcd2dkl3qvr
aws servicediscovery get-service --id srv-wsfa45thwlbuevyn &&   aws servicediscovery delete-service --id srv-wsfa45thwlbuevyn
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/1cc364d104ad9a87 &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/1cc364d104ad9a87
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2817/10c92c6700034f14 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2817/10c92c6700034f14
:
