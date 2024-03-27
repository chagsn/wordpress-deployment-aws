variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "azs" {
  description = "List of AZ where to deploy"
  type = list(string)
}

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type = string
}

variable "public_subnets_cidr" {
  description = "List of CIDRs for the public subnets"
  type = list(string)
}

variable "wordpress_subnets_cidr" {
  description = "List of CIDRs for the wordpress private subnets"
  type = list(string)
}

variable "database_subnets_cidr" {
  description = "List of CIDRs for the database private subnets"
  type = list(string)
}
