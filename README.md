Microservice Kubernetes Sample
=====================

This project creates a complete micro service demo system in Docker
containers. The services are implemented in Java using Spring and
Spring Cloud.

This project contains a demo micro-service system that can be deployed on any containerized environment.
There are three microservices:
- `Order` to process orders.
- `Customer` to handle customer data.
- `Catalog` to handle the items in the catalog.

- `apache` to provide the web page at port 8080

Apache HTTP is used to provide the web page of the demo at port 8080. It also forwards HTTP requests to the microservices. This
is not really necessary as each service has its own port on the host but it provides a single point of entry for the whole system.
Apache HTTP is configured as a reverse proxy for this.

###Project Modules

- [microservice-kubernetes-demo-catalog](microservice-kubernetes-demo/microservice-kubernetes-demo-catalog) is the application to take care of items.
- [microservice-kubernetes-demo-customer](microservice-kubernetes-demo/microservice-kubernetes-demo-customer) is responsible for customers.
- [microservice-kubernetes-demo-order](microservice-kubernetes-demo/microservice-kubernetes-demo-order) does order processing. It uses
  microservice-kubernetes-demo-catalog and microservice-kubernetes-demo-customer.
- [microservice-kubernetes-demo/apache](microservice-kubernetes-demo/apache/) is the apache load balancer

###How to run
---------
What you need
An Azure subscription

Prerequisites:
2. Install docker

3. Install helm

4. Install terraform

1. Login to Azure using Azure CLI
   az login
   
Create a Storage account to save the terraform state
Create a service principle to 


There are 3 main steps that need to be followed.

####Create Infrastructure


####Build Image


####Deploy Helm Chart

