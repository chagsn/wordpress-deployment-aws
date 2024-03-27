variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "ecs_security_group_id" {
  description = "ECS wordpress service security group id"
  type = string
}

variable "wordpress_subnet_ids" {
  description = "List of private subnets for wordpress instances"
  type = list(string)
}