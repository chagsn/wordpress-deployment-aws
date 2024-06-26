﻿# DevOps project: Highly-available Wordpress deployment on AWS

 This team project was developped with Serge Keita (https://github.com/sergemad) in the framework of our **Cloud/DevOps training bootcamp** at Datascientest.

  ## 1. Project objective and specifications
  The objective of the project was to **deploy Wordpress CMS on multiple webservers in the AWS cloud**.
  
  The deployment was expected to fulfill the the following requirements:
  - Ensure infrastructure **high-availability**
  - Use **containerization** and **containers orchestration**
  - **Automate** infrastructure deployment using **Infrastructure as Code** (IaC)
  - **Automate and test** IaC code deployment using a **CI/CD pipeline**

## 2. AWS architecture design

### Global architecture

The following figure illustrates the global target architecture designed to meet project objective & requirements as detailed above:

![image](https://github.com/chagsn/wordpress-deployment-aws/assets/102815082/64fbe7b9-2dde-4f51-95d8-df2679e25e5d)

The AWS infrastructure adheres to a classic **3-tier architecture**, including a **presentation** level, an **application** level (corresponding to Wordpress servers instances), and a **data** level (corresponding to Wordpress database).

It is deployed on 2 Avalaibility Zones (AZ) so as to ensure **high-availability**: the architecture is resilient in the event of a breakdown/failure of one of the AZ.

### Networking- VPC

The **Virtual Private Cloud (VPC)** is the foundation of the architecture. 
An **Internet Gateway (IG)** allows the communication between the VPC (for public subnets instances only) and the Internet.
The VPC structure is directly related to the **3-tier architecture**:
- The **presentation** layer is materialized by **public subnets** (one public subnet in each AZ), which contains the **Application Load Balancer (ALB)** and the **NAT Gateways (NAT GW)**. These NAT GW allow the instances located in the private subnets to initiate a connexion to access to resources located outside the VPC (external services cannot initiate a connection with those instances, which ensures private instances protection).
- Then a first pair of **private subnets**, corresponding to the **application** layer, is used to deploy the **Wordpress servers**.
- Finally the **data** layer is represented by a second pair of **private subnets**, which contain the **database** resources.

### ECS cluster + Fargate
As mentioned in the project specifications, the application must be deployed in containers managed by an **orchestration tool**, such as Kubernetes.
The AWS service dedicated to Kubernetes clusters management is named **Elastic Kubernetes Service (EKS)**. Nevertheless, in the framework of this project we have prefered to resort to **AWS-proprietary container orchestration service**, named **Elastic Container Service (ECS)**, for the following reasons:
- The use of Kubernetes did **not** present **any specific added value** with regard to the project objective,
- Deploying with ECS is globally **simpler**: we only have one provider to manage, and can avoid the relative complexity inherent to the use of Kubernetes,
- Deploying with ECS is **cheaper**: indeed EKS typically consumes more resources, and thus turns out to be more expensive than ECS.

Within the ECS cluster, the number of ECS Tasks is adjusted based on CPU and Memory usage, to adapt to the load (**ECS autoscaling**).

The containers underlying infrastructure is deployed using **Fargate**, which is a **serveless** AWS service that will automatically manage for us infrastructure provisioning, ECS tasks distribution on this infrastracture, as well as infrastructure autoscaling according to the number of ECS tasks running.

### Elastic File System

Wordpress application files are stored on the web server. In the present case, the application is deployed on multiple web servers across two AZ (one server on each ECS container), so we need a **multi-AZ shared storage solution** between ECS containers, so as to ensure **data consistency** whatever the web server the final user will be directed to. 
Moreover, the storage solution should also allow **data persistency** beyond **containers lifecycle**.

These storage requirements are fulfilled by an **Elastic File System (EFS)**, which is mounted on each ECS container through a **Mount Target** (one Mount Target in each AZ). 

As a **serverless service**, EFS also provides additional benefits: no infrastructure provisioning (fully managed by AWS), high-availability and automatic storage scaling based on data volume.

### RDS-MySQL database

Wordpress database is hosted on a **RDS-MySQL** database, in **multi-AZ configuration** to ensure high-availability.

Another option considered, which would have been even more interesting in terms of performance/scalability/availability, was **Amazon Aurora**. However, we ultimately chose RDS to keep costs down.

Access to the database is secured by a password managed with **Secrets Manager**.

### Application Load Balancer

Users HTTP(S) requests are routed to the Wordpress servers through an **Application Load Balancer (ALB)**, which distributes HTTP traffic to the various ECS Tasks. 

The ALB performs **health checks** on the ECS Tasks to route traffic only to healthy instances, and integrates seamlessly with ECS auto-scaling, ensuring optimal website availability.

### Cloudfront

**Cloudfront** is used to **optimize website performance**.

It is a **Content Delivery Network (CDN)**: it caches users requests results, and delivers content right from the Edge Locations, as close to the users as possible.

This allows to **reduce latency** and **offload traffic** from the Application Load Balancer (and thus from the web servers).
