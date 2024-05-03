#!/usr/bin/env bash

cd $(dirname $0)
find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate
sleep 10 # wait for ECS Services to be deleted
aws servicediscovery delete-service --id srv-oqkipfbr4ziqkm3m
aws servicediscovery delete-service --id srv-jmaafqsyirfxzub3
aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/19ff917e6a91339b
aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-dev-dk-2267-dreamkast/689d8c31230744ff
