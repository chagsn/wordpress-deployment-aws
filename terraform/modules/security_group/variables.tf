variable "env" {
  description = "Deployment environment: dev or prod"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "efs_security_group_id" {
  description = "ID of the EFS volume security group"
  type = string
}
