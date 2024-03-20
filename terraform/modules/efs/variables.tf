variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "wordpress_subnet_ids" {
  description = "List of private subnets where to deploy the ECS service"
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_subnet_cidr_block" {
  type = list(string)
}