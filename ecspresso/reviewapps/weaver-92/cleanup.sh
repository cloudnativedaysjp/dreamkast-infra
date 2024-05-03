#!/usr/bin/env bash

cd $(dirname $0)
find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery delete-service --id srv-f7pduvwkh3v4bzmb
aws elbv2 delete-rule --rule-arn 
aws elbv2 delete-target-group --target-group-arn 
