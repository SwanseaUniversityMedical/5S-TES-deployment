#!/bin/bash

# kind doesn't work on apple silicon if this is set
export DOCKER_DEFAULT_PLATFORM=
set DOCKER_DEFAULT_PLATFORM=

# create kind cluster with config
kind create cluster --config=files/kind-config.yaml

# install ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace -f files/ingress-nginx.yaml

# rewrite coredns
kubectl apply -f files/coredns.yaml

# install argo
helm repo add argo https://argoproj.github.io/argo-helm 
helm repo update
helm upgrade --install argocd argo/argo-cd -n argocd -f files/argo.yaml --create-namespace

# add repo and project
kubectl apply -f files/project.yaml
kubectl apply -f files/repo.yaml
kubectl apply -f files/app.yaml
kubectl create ns dare-control-submission
kubectl apply -f files/keycloak.yaml

# get the argo password and emit it
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
