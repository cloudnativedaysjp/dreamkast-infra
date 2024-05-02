#!/usr/bin/env bash

aws servicediscovery delete-service --id srv-oqkipfbr4ziqkm3m
aws servicediscovery delete-service --id srv-jmaafqsyirfxzub3
aws elbv2 delete-rule --rule-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:listener-rule/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5/4ebf26be08c605a6
aws elbv2 delete-target-group --target-group-arn arn:aws:elasticloadbalancing:us-west-2:607167088920:targetgroup/dreamkast-dev-dk-2267-dreamkast/b581b024f3ccea64
