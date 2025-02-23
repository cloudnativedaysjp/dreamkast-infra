#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

find . -name "ecspresso.jsonnet" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
find . -name "ecschedule_delete.jsonnet" | xargs -I{} -P10 ecschedule apply -conf {} -all -prune -dry-run ||:
find . -name "ecschedule_delete.jsonnet" | xargs -I{} -P10 ecschedule apply -conf {} -name dk-2487-harvestjob -prune ||:
#find . -name "ecschedule_delete.jsonnet" | xargs -I{} -P10 ecschedule apply -conf {} -all -prune -dry-run ||:
sleep 10 # wait for ECS Services to be deleted
#aws events describe-rule --name dk-2487-harvestjob &&   aws events delete-rule --name dk-2487-harvestjob --force
#aws ecs describe-task-definition --task-definition dreamkast-dev-dk-2487-harvestjob &&   aws ecs deregister-task-definition --task-definition dreamkast-dev-dk-2487-harvestjob
aws servicediscovery get-service --id srv-mim5vhv7bpntae6i &&   aws servicediscovery delete-service --id srv-mim5vhv7bpntae6i
aws servicediscovery get-service --id srv-k5wgor5xwurorusv &&   aws servicediscovery delete-service --id srv-k5wgor5xwurorusv
aws elbv2 describe-rules --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/55ad0a72858a96b6 &&   aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/55ad0a72858a96b6
aws elbv2 describe-target-groups --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2487/4d55974402b86d74 &&   aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dev-dk-2487/4d55974402b86d74
:
