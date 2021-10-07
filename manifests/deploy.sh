#!/usr/bin/env bash

set -e -o pipefail
cd $(dirname $0)

# NOTE: Requirement
## https://github.com/kubernetes/kubectl
## https://github.com/kubernetes-sigs/kustomize


function _usage() {
cat << _EOF_
Usage:
  $0 [command] -e \$ENVIRONMENT

Commands:
  apply     apply ArgoCD
  dry-run   run "kustomize build \$MANIFEST_OVERLAY_DIR", do not apply
  delete    delete ArgoCD
  help      show usages
_EOF_
}

function _confirmation() {
  echo "current context: $(kubectl config current-context)"
  read -p "OK? [y/N]: " CONFIRMATION;
  if [[ "$CONFIRMATION" != y ]]; then exit 0; fi
}

function _setup() {
  if [ ! -e ${MANIFEST_OVERLAY_DIR}/secret-argocd.yaml ]; then
    ### user input ###
    : ${ARGOCD_SECRETKEY:=$(read -sp "input ArgoCD secretKey: " VAR; echo $VAR)}; echo ... 1>&2
    : ${ARGOCD_PASSWORD:=$(read -sp "input ArgoCD password: " VAR; echo $VAR)}; echo ... 1>&2
    : ${CLIENT_SECRET:=$(read -sp "input Auth0 ClientSecret: " VAR; echo $VAR)}; echo ... 1>&2

    ### create secret.yaml file
    echo "---" > ${MANIFEST_OVERLAY_DIR}/secret-argocd.yaml
    kubectl create secret generic argocd-secret \
      --from-literal=server.secretkey=${ARGOCD_SECRETKEY} \
      --from-literal=admin.password=$(htpasswd -nbBC 10 "" ${ARGOCD_PASSWORD} | tr -d ':\n' | sed 's/$2y/$2a/') \
      --from-literal=oidc.auth0.clientSecret=${CLIENT_SECRET} \
      --dry-run=client -o yaml >> ${MANIFEST_OVERLAY_DIR}/secret-argocd.yaml
  fi

  if [ ! -e ${MANIFEST_OVERLAY_DIR}/secret-git-creds.yaml ]; then
    ### user input ###
    : ${GITHUB_USERNAME:=$(read -sp "input GitHub Username: " VAR; echo $VAR)}; echo ... 1>&2
    : ${GITHUB_TOKEN:=$(read -sp "input GitHub Token: " VAR; echo $VAR)}; echo ... 1>&2

    ### create secret files ###
    echo "---" > ${MANIFEST_OVERLAY_DIR}/secret-git-creds.yaml
    kubectl create secret generic git-creds \
      --from-literal=username=${GITHUB_USERNAME} \
      --from-literal=password=${GITHUB_TOKEN} \
      --dry-run=client -o yaml >> ${MANIFEST_OVERLAY_DIR}/secret-git-creds.yaml
  fi
}

function _build() {
  kustomize build ${MANIFEST_OVERLAY_DIR}
}

function _delete() {
  kustomize build ${MANIFEST_BASE_DIR} | kubectl delete -f -
}

function _err_invalid_args() {
  echo "invalid arguments"
  _usage $1 ${2:-""}
  exit 1
}


function _parse_options() {
  # parse options
  while getopts e: OPT
  do
    case $OPT in
      e)
        ENVIRONMENT=$OPTARG
        ;;
    esac
  done

  # set variables
  MANIFEST_APPLICATION_FILE=./application-${ENVIRONMENT}.yaml
  MANIFEST_BASE_DIR=./argocd/base
  MANIFEST_OVERLAY_DIR=./argocd/overlays/${ENVIRONMENT}-with-secrets

  # validate variables
  if [ ! "${ENVIRONMENT:+empty}" ]; then echo "-e option must required"; exit 1; fi
  if [ ! -f $MANIFEST_APPLICATION_FILE ]; then echo "$MANIFEST_APPLICATION_FILE: no such files"; exit 1; fi
  if [ ! -d $MANIFEST_BASE_DIR ]; then echo "$MANIFEST_BASE_DIR: no such directory"; exit 1; fi
  if [ ! -d $MANIFEST_OVERLAY_DIR ]; then echo "$MANIFEST_OVERLAY_DIR: no such directory"; exit 1; fi
}

function main() {
  if [ $# -eq 0 ]; then _usage $0; exit 1; fi
  case "$1" in
    "apply" )
      _parse_options ${@:2}
      _setup
      _confirmation
      _build | kubectl apply -f -
      kubectl apply -f $MANIFEST_APPLICATION_FILE
      ;;
    "dry-run" )
      _parse_options ${@:2}
      _setup
      _build
      ;;
    "delete" )
      _parse_options ${@:2}
      _confirmation
      _delete
      ;;
    "help" )
      _usage $0
      ;;
    * )
      _err_invalid_args $0
      ;;
  esac
}

main $@
