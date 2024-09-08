#!/usr/bin/env bash
set -e -o pipefail
cd $(dirname $0)

# required the following commands:
# * aws
# * jq
# * jsonnet
# * jsonnetfmt

# variables
PR_NAME=${PR_NAME:?"PR_NAME must be specified"}
PR_NUMBER=${PR_NUMBER:?"PR_NUMBER must be specified"}
IMAGE_TAG=${IMAGE_TAG:?"IMAGE_TAG must be specified"}
LISTENER_RULE_PRIORITY_BASE=10000
LISTENER_RULE_PRIORITY=$(( LISTENER_RULE_PRIORITY_BASE + PR_NUMBER ))

VPC_ID="vpc-0f0d012967c635f34"
LISTENER_ARN="arn:aws:elasticloadbalancing:us-west-2:607167088920:listener/app/dreamkast-dev/122c5b4a47b64f9d/bc86e7b2e4bca8f5"
SERVICE_DISCOVERY_NAMESPACE="ns-53ijjrlltqf5r2gm"


if [ ! -f "cleanup.sh" ]; then
# create TargetGroup
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
  --name "dev-${PR_NAME}" \
  --target-type ip \
  --protocol HTTP \
  --port 3000 \
  --vpc-id ${VPC_ID} \
  --ip-address-type ipv4 \
  --health-check-path "/cnds2024/ui" \
  | jq -r ".TargetGroups[0].TargetGroupArn")

# create ALB ListenerRule
LISTENER_RULE_ARN=$(aws elbv2 create-rule --listener-arn ${LISTENER_ARN} \
  --priority ${LISTENER_RULE_PRIORITY} \
  --conditions Field=host-header,Values="dreamkast-${PR_NAME}.dev.cloudnativedays.jp" \
  --actions Type=forward,TargetGroupArn=${TARGET_GROUP_ARN} \
  | jq -r ".Rules[] | select(.Priority == \"${LISTENER_RULE_PRIORITY}\") | .RuleArn")

# replace variables in each ecspresso.yml
find . -name ecspresso.yml | xargs -I{} sed -i -e 's/__PR_NAME__/'${PR_NAME}'/g' {}

# replace variables in const.libsonnet
cat << _EOL_ | jsonnet - > ./const.libsonnet.tmp
local const = import './const.libsonnet';

const + {
  PR_NAME: "${PR_NAME}",
  targetGroupArn: {
    dkUi: "${TARGET_GROUP_ARN}",
  },
  imageTags: const.imageTags + {
    dreamkast_ui: "${IMAGE_TAG}",
  },
}
_EOL_
mv const.libsonnet.tmp const.libsonnet

# create cleanup.sh
cat << _EOF_ > ./cleanup.sh
#!/usr/bin/env bash
set -e -o pipefail
cd \$(dirname \$0)

find . -name "ecspresso.yml" | xargs -I{} -P10 ecspresso --config={} delete --force --terminate ||:
aws elbv2 describe-rules --rule-arn ${LISTENER_RULE_ARN} &>/dev/null && aws elbv2 delete-rule --rule-arn ${LISTENER_RULE_ARN}
aws elbv2 describe-target-groups --target-group-arn ${TARGET_GROUP_ARN} &>/dev/null && aws elbv2 delete-target-group --target-group-arn ${TARGET_GROUP_ARN}
_EOF_

else
# update imageTags
jsonnet const.libsonnet \
  | jq ".imageTags.dreamkast_ui|=\"${IMAGE_TAG}\"" \
  > const.libsonnet.tmp
mv const.libsonnet.tmp const.libsonnet

fi

jsonnetfmt -i const.libsonnet
