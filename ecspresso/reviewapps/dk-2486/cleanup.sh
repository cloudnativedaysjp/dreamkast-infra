#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
sleep 10 # wait for ECS Services to be deleted
aws events describe-rule --name dk-2486-harvestjob &&   aws events delete-rule --name dk-2486-harvestjob --force
aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2486-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2486-harvestjob
aws servicediscovery get-service --id srv-tt7ltwz53ycyuaf4 &&   aws servicediscovery delete-service --id srv-tt7ltwz53ycyuaf4
aws servicediscovery get-service --id srv-s6fv32g3f5awbwdn &&   aws servicediscovery delete-service --id srv-s6fv32g3f5awbwdn
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/64f6d1b6dee5e216 &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/64f6d1b6dee5e216
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2486/3c597e5646132c4e &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2486/3c597e5646132c4e
:
