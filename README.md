
  

  

# Microservice Kubernetes Sample

  

  

=====================

  

  

This project creates a complete micro service demo system in Docker containers. The services are implemented in Java using Spring and Spring Cloud.

  

  

This project contains a demo micro-service system that can be deployed on any containerized environment.

  

  

There are three microservices:

  

  

-  `Order` to process orders.

  

  

-  `Customer` to handle customer data.

  

  

-  `Catalog` to handle the items in the catalog.

  

  

-  `apache` to provide the web page at port 8080

  

  

  

Apache HTTP is used to provide the web page of the demo at port 8080. It also forwards HTTP requests to the microservices. This

  

  

is not really necessary as each service has its own port on the host but it provides a single point of entry for the whole system.

  

  

Apache HTTP is configured as a reverse proxy for this.

  

  

  

### Project Modules

  

  

  

-  [microservice-kubernetes-demo-catalog](microservice-kubernetes-demo/microservice-kubernetes-demo-catalog) is the application to take care of items.

  

  

-  [microservice-kubernetes-demo-customer](microservice-kubernetes-demo/microservice-kubernetes-demo-customer) is responsible for customers.

  

  

-  [microservice-kubernetes-demo-order](microservice-kubernetes-demo/microservice-kubernetes-demo-order) does order processing. It uses

  

  

microservice-kubernetes-demo-catalog and microservice-kubernetes-demo-customer.

  

  

-  [microservice-kubernetes-demo/apache](microservice-kubernetes-demo/apache/) is the apache load balancer

  

  

  

## How to run

  

  

Before you start,

  

  

* Make sure you have a valid Azure subscription and have read/write access to it

  

  

  

* Make sure Docker is installed

  

  

  

* Make sure kubectl is installed

  

  

  

* Make sure Helm is installed

  

  

  

* Make sure Terraform is installed

  

  

  

* Make sure Azure CLI is installed

  

  

  

### Prerequisites

######You need to create an Azure storage account to store the Terraform state. Run the following commands to create the storage account.


`export RESOURCE_GROUP_NAME=tfstate`


`export STORAGE_ACCOUNT_NAME=tfstate$RANDOM`


`export CONTAINER_NAME=tfstate`

`export SUBSCRIPTION_ID=<your Azure subscription ID>`
###

* Login to Azure using Azure CLI

`az login`

* Create resource group

`az group create --name $RESOURCE_GROUP_NAME --location centralus`

* Create storage account

`az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob`

* Create blob container

`az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME`

`ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)`

`export ARM_ACCESS_KEY=$ACCOUNT_KEY`


###
######You need to create an Azure service principal to authenticate the kuberenetes cluster to pull images from container registry. Run the following commands.

* Create a Service principal

`az ad app create --display-name AKSClusterServicePrincipal`

Note the <b>appId</b> in the output.

`az ad app credential reset --id <appId> --append`

Note the <b>password</b> in the output

`export TF_VAR_client_id=<appId>`

`export TF_VAR_client_secret=<password>`


## Deployment

  

There are 3 main steps that need to be followed.

  

  

  

#### Provision infrastructure resources

  

Run microservice-aks-demo/terraform/script.sh

  

You will be listed with a plan on the resources that will be created, updated or destroyed. Afterwards you will be prompted for a confirmation to provision the resources where you will need to input 'yes' to continue.

  

Once the script is completed it will create the necessary resources. You will see that the `publicIp` is printed in the terminal. You will have to copy this value and add it in the microservice-aks-demo/helm/cw/templates/apache-service.yaml in the last line as the value for `ip`.

  

  

#### Build Image

  

Run microservice-aks-demo/microservice-kubernetes-demo/docker-build.sh to build and push the images to the container registry

  

  

#### Deploy Helm Chart

  

Run `helm install cw cw -n cw` to deploy the microservices