variable "env" {
  description = "Deployment environment: dev or prod"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of ids for the public subnets"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID du security group de l'ALB"
  type        = string
}
