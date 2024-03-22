variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "wordpress_subnet_ids" {
  description = "List of private subnets for wordpress instances"
  type = list(string)
}