#!/bin/bash
git clone https://github.com/ewolff/microservice-kubernetes.git && cd "$(basename "$_" .git)"/microservice-kubernetes-demo


ACR_ACCOUNT=k8sacrcw1
ACR=$ACR_ACCOUNT\.azurecr.io

az login
# az login -u <username> -p <password>
az acr login --name k8sacrcw1


docker build --tag=microservice-kubernetes-demo-apache apache
docker tag microservice-kubernetes-demo-apache $ACR/microservice-kubernetes-demo-apache:latest
docker push $ACR/microservice-kubernetes-demo-apache

docker build --tag=microservice-kubernetes-demo-catalog microservice-kubernetes-demo-catalog
docker tag microservice-kubernetes-demo-catalog $ACR/microservice-kubernetes-demo-catalog:latest
docker push $ACR/microservice-kubernetes-demo-catalog

docker build --tag=microservice-kubernetes-demo-customer microservice-kubernetes-demo-customer
docker tag microservice-kubernetes-demo-customer $ACR/microservice-kubernetes-demo-customer:latest
docker push $ACR/microservice-kubernetes-demo-customer

docker build --tag=microservice-kubernetes-demo-order microservice-kubernetes-demo-order
docker tag microservice-kubernetes-demo-order $ACR/microservice-kubernetes-demo-order:latest
docker push $ACR/microservice-kubernetes-demo-order

az account set --subscription e09e86bd-72af-4d1d-a108-245297fba268
az aks get-credentials --resource-group azure-k8stest --name k8stest --admin
kubectl apply -f microservices.yaml