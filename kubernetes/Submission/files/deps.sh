#!/bin/bash

helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo add minio https://operator.min.io/   
helm repo update

helm upgrade --install minio-operator minio/operator \
	-n minio-operator --create-namespace --version 7.1.1

helm upgrade --install cloudnative-pg cnpg/cloudnative-pg \
	-n cnpg-system --create-namespace --version 0.26.1

helm upgrade --install rabbitmq-cluster-operator oci://registry-1.docker.io/bitnamicharts/rabbitmq-cluster-operator \
	-n rabbitmq-system --create-namespace --version 4.4.34 \
	--set clusterOperator.watchAllNamespaces=true \
	--set clusterOperator.image.repository=bitnamilegacy/rabbitmq-cluster-operator \
	--set msgTopologyOperator.enabled=true \
	--set msgTopologyOperator.watchAllNamespaces=true \
	--set msgTopologyOperator.image.repository=bitnamilegacy/rmq-messaging-topology-operator \
	--set rabbitmqImage.repository=bitnamilegacy/rabbitmq \
	--set credentialUpdaterImage.repository=bitnamilegacy/rmq-default-credential-updater

