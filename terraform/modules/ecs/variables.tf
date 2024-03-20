variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "alb_target_group_id" {
  description = "ARN of the target group of the ALB spreading trafic to the cluster"
  type = string
}

variable "autoscaling_range" {
  description = "Map of minimum and maximum capacities for ECS service servautoscaling: {min_capacity,max_capacity}"
  type = map(number)
}

variable "wordpress_subnet_ids" {
  description = "List of private subnets where to deploy the ECS service"
  type = list(string)
}

variable "efs_id" {
  description = "ARN of the shared EFS to mount on containers for persistent wordpress data storage"
  type = string
}

variable "wordpress_image" {
  description = "Required data to pull wordpress image: {repo_url,image_tag}"
  type = map(string)
}

variable "rds_database" {
  description = "RDS database outputs: {db_address,db_username,db_password,db_name}"
  type = map(string)
}