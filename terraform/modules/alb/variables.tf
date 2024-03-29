variable "env" {
  description = "Deployment environment: dev or prod"
  type        = string
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of IDs for the public subnets"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of ALB security group"
  type        = string
}
 variable "health_check_path" {
  description = "Destination URI for the target group health checks"
  type = string
 }
