# Environnement
variable "allowed_env" {
  description = "Allowed values for environment"
  type        = list(string)
  default     = ["dev", "prod"]
}

# Availability zones and backup region
variable "azs" {
  description = "List of AZ where to deploy"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "backup_region" {
  description = "Backup region"
  type        = string
  default     = "us-east-1"
}

# Networking
variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = map(string)
  # Dev and prod VPC do not overlap to allow deploying both environments at the same time
  default = {
    default = "10.0.0.0/20"
    dev     = "10.0.0.0/20"
    prod    = "10.0.16.0/20"
  }
}

variable "public_subnets_cidr" {
  description = "List of CIDRs for the public subnets"
  type        = map(list(string))
  default = {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
    dev     = ["10.0.1.0/24", "10.0.2.0/24"]
    prod    = ["10.0.17.0/24", "10.0.18.0/24"]
  }
}

variable "wordpress_subnets_cidr" {
  description = "List of CIDRs for the wordpress private subnets"
  type        = map(list(string))
  default = {
    default = ["10.0.3.0/24", "10.0.4.0/24"]
    dev     = ["10.0.3.0/24", "10.0.4.0/24"]
    prod    = ["10.0.19.0/24", "10.0.20.0/24"]
  }
}

variable "database_subnets_cidr" {
  description = "List of CIDRs for the database private subnets"
  type        = map(list(string))
  default = {
    default = ["10.0.5.0/24", "10.0.6.0/24"]
    dev     = ["10.0.5.0/24", "10.0.6.0/24"]
    prod    = ["10.0.21.0/24", "10.0.22.0/24"]
  }
}

# Database configuration
variable "db_engine" {
  description = "Engine configuration for the database:{engine,engine_version,family,major_engine_version}"
  type        = map(string)
  default = {
    engine               = "mysql"
    engine_version       = "8.0"
    family               = "mysql8.0"
    major_engine_version = "8.0"
  }
}

variable "db_instance_class" {
  description = "Instance class of the database"
  type        = map(string)
  default = {
    default = "db.t3.small"
    dev     = "db.t3.small"
    prod    = "db.t3.large"
  }
}

variable "db_storage_sizing" {
  description = "Storage sizing of the database"
  type        = map(map(number))
  default = {
    default = {
      allocated_storage     = 20
      max_allocated_storage = 100
    }
    dev = {
      allocated_storage     = 20
      max_allocated_storage = 100
    }
    prod = {
      allocated_storage     = 30
      max_allocated_storage = 150
    }
  }
}

variable "db_maintenance_window" {
  description = "Window to perform database maintenance"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "stormpoeiweb2"
}
variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "wordpress"
}
variable "db_password_automatic_rotation_schedule" {
  description = "Number of days between automatic scheduled rotations of the secret containing the DB password"
  type        = number
  default     = 30
}

# ECS configuration
variable "fargate_capacity_provider_strategy" {
  description = "Allocation strategy between Fargate-standard and Fargate-spot capacity providers:{Fargate_weight,Fargate_spot_weight}"
  type        = map(map(number))
  default = {
    default = {
      FARGATE      = 25
      FARGATE_SPOT = 75
    }
    dev = {
      FARGATE      = 25
      FARGATE_SPOT = 75
    }
    prod = {
      FARGATE      = 75
      FARGATE_SPOT = 25
    }
  }
}

variable "ecs_autoscaling_range" {
  description = "Map of minimum and maximum capacities for ECS service servautoscaling: {min_capacity,max_capacity}"
  type        = map(map(number))
  default = {
    default = {
      min_capacity = 1
      max_capacity = 4
    }
    dev = {
      min_capacity = 1
      max_capacity = 4
    }
    prod = {
      min_capacity = 2
      max_capacity = 8
    }
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

variable "wordpress_containers_sizing" {
  description = "CPU and memory sizing for wordpress containers: {cpu, memory}"
  type        = map(map(number))
  default = {
    default = {
      cpu    = 512
      memory = 2048
    }
    dev = {
      cpu    = 512
      memory = 2048
    }
    prod = {
      cpu    = 1024
      memory = 4096
    }
  }
}

# ALB configuration
variable "alb_health_check_path" {
  description = "URI used by the ALB to check wordpress application health"
  type        = string
  default     = "/wp-load.php"
}

# Route 53 configuration
variable "domain_name" {
  description = "Hosted zone name"
  type        = string
  default     = "stormpoei-web2.com"
}

variable "subdomain_name" {
  description = "Subdomain name for wordpress website"
  type        = string
  default     = "wordpress"
}