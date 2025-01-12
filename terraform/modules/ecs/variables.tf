variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "capacity_provider_strategy" {
  description = "Allocation strategy between Fargate-standard and Fargate-spot capacity providers:{Fargate_weight,Fargate_spot_weight}"
  type = map(number)
}

variable "alb_target_group_id" {
  description = "ARN of the target group of the ALB distributing traffic to the ECS service"
  type = string
}

variable "autoscaling_range" {
  description = "Minimum and maximum capacities for ECS service autoscaling: {min_capacity,max_capacity}"
  type = map(number)
}

variable "wordpress_subnet_ids" {
  description = "List of private subnets where to deploy the ECS service"
  type = list(string)
}

variable "security_group_id" {
  description = "ID of the security group to attach to the ECS service"
  type = string
}

variable "efs_id" {
  description = "ID of the shared EFS to mount on containers for persistent wordpress data storage"
  type = string
}
variable "efs_arn" {
  description = "ARN of the shared EFS to mount on containers for persistent wordpress data storage"
  type = string
}

variable "rds_db_data" {
  description = "RDS database data: address, username, database name, and ARN of the secret created in Secrets Manager containing the DB password"
  type = map(string)
}

variable "wordpress_image" {
  description = "Required data to pull wordpress image: {repo_url,image_tag}"
  type = map(string)
}

variable "containers_sizing" {
  description = "CPU and memory sizing for wordpress containers: {cpu, memory}"
  type = map(number)
}