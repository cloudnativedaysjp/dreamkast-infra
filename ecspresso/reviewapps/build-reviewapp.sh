#!/usr/bin/env bash

cd "$(dirname $0)"

REPOSITORY_NAME=${REPOSITORY_NAME:?"REPOSITORY_NAME must be specified"}
PR_NUMBER=${PR_NUMBER:?"PR_NUMBER must be specified"}
IMAGE_TAG=${IMAGE_TAG:?"IMAGE_TAG must be specified"}

case $REPOSITORY_NAME in
  "cloudnativedaysjp/dreamkast")
    TEMPLATE_DIR="template-dk"
    export PR_NAME="dk-${PR_NUMBER}"
    ;;
  "cloudnativedaysjp/dreamkast-ui")
    TEMPLATE_DIR="template-ui"
    export PR_NAME="ui-${PR_NUMBER}"
    ;;
  "cloudnativedaysjp/dreamkast-weaver")
    TEMPLATE_DIR="template-weaver"
    export PR_NAME="weaver-${PR_NUMBER}"
    ;;
  *)
    echo "REPOSITORY_NAME $REPOSITORY_NAME is not supported"
    exit 1
esac

[ ! -d ${PR_NAME} ] && cp -a $TEMPLATE_DIR $PR_NAME
bash -x $PR_NAME/initialize.sh
