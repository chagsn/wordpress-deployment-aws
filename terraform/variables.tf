variable "env" {
  description = "Deployment environment: dev or prod"
  type        = string
  default     = "dev"
}

variable "azs" {
  description = "List of AZ where to deploy"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

# Networking
variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "List of CIDRs for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "wordpress_subnets_cidr" {
  description = "List of CIDRs for the wordpress private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets_cidr" {
  description = "List of CIDRs for the database private subnets"
  type        = list(string)
  default     = ["10.0.201.0/24", "10.0.202.0/24"]
}

# Database informations
variable "db_name" {
  type    = string
  default = "wordpress" # A modifier après intégration du module SecretsManager
}

variable "db_username" {
  type    = string
  default = "wp_user" # A modifier après intégration du module SecretsManager
}

variable "db_password" {
  type    = string
  default = "supersecretpassword" # A modifier après intégration du module SecretsManager
}

# ECS configuration
variable "fargate_capacity_provider_strategy" {
  description = "Allocation strategy between Fargate-standard and Fargate-spot capacity providers:{Fargate_weight,Fargate_spot_weight}"
  type        = map(number)
  default = {
    FARGATE      = 60
    FARGATE_SPOT = 40
  }
}

variable "ecs_autoscaling_range" {
  description = "Map of minimum and maximum capacities for ECS service servautoscaling: {min_capacity,max_capacity}"
  type        = map(number)
  default = {
    min_capacity = 1
    max_capacity = 4
  }
}

variable "wordpress_image" {
  description = "Required data to pull wordpress image: {repo_url,image_tag}"
  type        = map(string)
  default = {
    repo_url  = "public.ecr.aws/docker/library/wordpress"
    image_tag = "php8.3"
  }
}


# ALB configuration
variable "alb_health_check_path" {
  description = "URI used by the ALB to check wordpress application health"
  type        = string
  default     = "/wp-load.php"
}

variable "domain_name" {
  type = string
  default = "stormpoei-web2.com"
}

variable "subdomain" {
  type = string
  default = "Wordpress"

}