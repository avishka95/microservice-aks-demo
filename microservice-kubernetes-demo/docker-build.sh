#!/bin/bash

RED='\033[01;31m'
GREEN='\033[01;32m'
DEFAULT='\033[00m'
BOLD='\033[1m'
YELLOW='\033[0;33m'

command -v git >/dev/null 2>&1 || {
    echo -e >&2 "${RED}git cannot be found. Follow https://git-scm.com/book/en/v2/Getting-Started-Installing-Git to install git."
    echo -e >&2 "Aborting...${DEFAULT}"
    exit
}

echo -e "${BOLD}Initializing source code...${DEFAULT}"

if [ ! -d "microservice-kubernetes/microservice-kubernetes-demo" ]
then
  echo -e "${YELLOW}Cloning source at https://github.com/avishka95/microservice-aks-demo.git${DEFAULT}"
  git clone https://github.com/avishka95/microservice-aks-demo.git && cd "$(basename "$_" .git)"/microservice-kubernetes-demo
else
  cd microservice-kubernetes/microservice-kubernetes-demo
fi

./mvnw clean package -Dmaven.test.skip=true

ACR_ACCOUNT=k8sacrcw1
ACR=$ACR_ACCOUNT\.azurecr.io

echo -e "${BOLD}Logging to Azure CLI...${DEFAULT}"
az login

echo -e "${BOLD}Logging to Container registry...${DEFAULT}"
az acr login --name k8sacrcw1

echo -e "${BOLD}Building image ${YELLOW} for apache ...${DEFAULT}"
docker build --tag=microservice-kubernetes-demo-apache apache

echo -e "${BOLD}Push image ${YELLOW} for apache ...${DEFAULT}"
docker tag microservice-kubernetes-demo-apache $ACR/microservice-kubernetes-demo-apache:latest
docker push $ACR/microservice-kubernetes-demo-apache

echo -e "${BOLD}Building image ${YELLOW} for catalog...${DEFAULT}"
docker build --tag=microservice-kubernetes-demo-catalog microservice-kubernetes-demo-catalog

echo -e "${BOLD}Push image ${YELLOW} for catalog ...${DEFAULT}"
docker tag microservice-kubernetes-demo-catalog $ACR/microservice-kubernetes-demo-catalog:latest
docker push $ACR/microservice-kubernetes-demo-catalog

echo -e "${BOLD}Building image ${YELLOW} for customer...${DEFAULT}"
docker build --tag=microservice-kubernetes-demo-customer microservice-kubernetes-demo-customer

echo -e "${BOLD}Push image ${YELLOW} for customer ...${DEFAULT}"
docker tag microservice-kubernetes-demo-customer $ACR/microservice-kubernetes-demo-customer:latest
docker push $ACR/microservice-kubernetes-demo-customer

echo -e "${BOLD}Building image ${YELLOW} for order...${DEFAULT}"
docker build --tag=microservice-kubernetes-demo-order microservice-kubernetes-demo-order

echo -e "${BOLD}Push image ${YELLOW} for order ...${DEFAULT}"
docker tag microservice-kubernetes-demo-order $ACR/microservice-kubernetes-demo-order:latest
docker push $ACR/microservice-kubernetes-demo-order

az account set --subscription 748682ec-ab94-4a8a-b556-14d7f372734c
az aks get-credentials --resource-group azure-k8stest --name k8stest --admin
kubectl create ns cw
cd ../helm
helm install cw --generate-name