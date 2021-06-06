#!/usr/bin/env bash

set -eu -o pipefail
cd $(dirname $0)

### Requirement
# https://github.com/kubernetes/kubectl
# https://github.com/junegunn/fzf

# directory paths
manifest_base_dir=./argocd/base
clusters="$(ls .apps/overlays)"


function _usage() {
cat << _EOF_
Usage:
  $0 [command]

Commands:
  apply     apply ArgoCD
  dry-run   dry-run ArgoCD
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
  # set global variables
  cluster_name="${CLUSTER_NAME:=$(echo $clusters | fzf)}"
  manifest_overlay_dir="./argocd/overlays/${cluster}_with-secrets"

  # create secrets
  if [ ! -e ${manifest_overlay_dir}/secret-argocd.yaml ]; then
    ### user input ###
    : ${AUTH0_CLIENT_SECRET:=$(read -sp "input Auth0 Client Secret: " VAR; echo $VAR)}; echo ... 1>&2

    ### create secret.yaml file
    echo "---" > ${manifest_overlay_dir}/secret-argocd.yaml
    kubectl create secret generic argocd-secret \
      --from-literal=oidc.auth0.clientSecret=${AUTH0_CLIENT_SECRET} \
      --dry-run=client -o yaml >> ${manifest_overlay_dir}/argocd-secret.yaml
  fi
}

function _build() {
  kustomize build ${manifest_overlay_dir}
}

function _apply_init_application() {
cat << _EOF_
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: applications
  namespace: argocd
spec:
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: https://github.com/cloudnativedaysjp/dreamkast-infra.git
    path: manifests/.apps/overlays/${cluster_name}
    targetRevision: main
_EOF_
}

function _delete() {
  kustomize build ${manifest_base_dir} | kubectl delete -f -
}

function _err_invalid_args() {
  echo "invalid arguments"
  _usage $1
  exit 1
}


function main() {
  if [ $# -eq 0 ]; then _usage $0; exit 1; fi
  case "$1" in
    "apply" )
      _setup
      _confirmation
      _build | kubectl apply -f -
      _apply_init_application
      ;;
    "dry-run" )
      _setup
      _build
      ;;
    "delete" )
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
