# Wordspress_deploy

**Proposed plan for this project**

**Provisioning VPC, ECS, & ALB using Terraform:**
  In project we are creating the infrastructure using Terraform on AWS cloud provider and attached the terraform script on the git public repo 
Project infrastructure have following: 
1.VPC with 3 public subnets in 3 availability zones
2. Elastic Cloud Container (ECS) 
3. Application Load Balancer (ALB)
4. Auto scaling group (ASG)
5. IAM Roles & permissions (IAM)

Description of each file 
ECS.TF:
•	Created the cluster of ECS container in the resource aws_ecs_cluster as wordpress_cluster
•	EC2 container cluster name is refernce from the variable file using the var. cluster name as terraform_wordpress_clusterr
•	Cluster is created using the EC2 launch type and created the capacity provider in the cluster

Capacity Provider
•	In the capacity provider have created the Auto scaling group where capacity providers manage the scaling of the infrastructure for tasks in the cluster
•	In the capacity providers enable the manage scaling with the target capacity as 85% where instance will be scale in automatically, if no tasks are running and scale out if the capacity is at greater than 85 %
ECS Task_defintions
•	In the ecs_task_defintion as Web-family where containers for ECS task are defined in the JSON file container-def.json
•	In the JSON file define the image to start the containers where WordPress image will be directly pull from docker hub & define memory, cpu & Port mappings 
•	In task definitions Network mode is bridge where task uses the Docker built-in virtual network
ECS Task Service
•	  In the ecs_service as web_service have set the desired count as 2 where we can run the 2 tasks parallel on cluster
•	In the ECS service mention the launch type of cluster as EC2 and configure the application load balancers which is used to distribute the traffic 
•	Define the binpack task placement strategy where task will be placed on the instance based on memory
•	Define the cloud watch log group used to grouping the logs & monitor the resources


ASG.TF
•	In launch configuration is instance configuration template to launch instances have define the AMI Image, instance type, IAM instance and user data 
•	In Security groups have defined the inbound rules & outbound rules with the CIDR blocks    value
•	In autoscaling group define the scaling polices, launch configuration templates & Health check details & Enabled the protect from scale in order to enable manage scaling in ECS container

ALB.TF
•	 In Target group used to route the request to one or more registered targets and configure the health checks per target have define the target_type, protocol, ports& Health check to perform on each targets
•	Created the load balancers resources by defining the type of lb, security groups, subnets
•	In the security group define the inbound, outbound rules & CIDR block values
•	In lb_listerner define the port protocol and routing policy and target group arn

IAM.TF 
•	In IAM role define the policy document define the Assume role which is credentials to authenticate against AWS
•	In IAM role  policy attachment define the policy arn, role arn and instance profile are used to pass the role to EC2 instance and define the role in the resource instance profile 

VPC.TF
•	 In VPC module is imported from the terraform registry in the vpc define the CIDR value, created 3 availability zones, 3 subnets
MAIN.TF
•	 In provider aws define the default region, shared_credentials_file & profile details
•	In storing the terraform state file in the S3 bucket using the terraform module

**To create the infrastructure **
Integrate the AWS account and Terraform CLI using the aws configure 
1.	Terraform init
2.	Terraform plan
3.	Terraform apply 
4.	Terraform destroy    - To destroy the infrastructure








