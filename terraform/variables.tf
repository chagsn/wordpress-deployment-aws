variable "env" {
  type    = string
  default = "dev"
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}

variable "db_username" {
  type    = string
  default = "user" # A modifier après intégration du module SecretsManager
}

variable "db_password" {
  type    = string
  default = "supersecretpassword" # A modifier après intégration du module SecretsManager
}

variable "encryption_key" {
  type    = string
  default = "arn:aws:kms:eu-west-3:962480255828:key/66c16fcc-ea7f-4aca-8dc1-8ecab3477e49"
}

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
    max_capacity = 1
  }
}

variable "wordpress_image" {
  description = "Required data to pull wordpress image: {repo_url,image_tag}"
  type        = map(string)
  default = {
    repo_url  = "public.ecr.aws/docker/library/wordpress"
    image_tag = "beta-php8.3-fpm-alpine"
  }
}
