# Configuration du cluster ECS
module "wordpress-cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.10.0"

  cluster_name = "wordpress"
  
  # Capacity provider: Fargate
  default_capacity_provider_use_fargate = true
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = var.capacity_provider_strategy["FARGATE"]
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = var.capacity_provider_strategy["FARGATE_SPOT"]
      }
    }
  }

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

}

# Configuration du service ECS déployant les Tasks
module "wordpress-service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.10.0"

  name        = "wordpress"
  cluster_arn = module.wordpress-cluster.id

  cpu    = 1024
  memory = 4096

  network_mode = "awsvpc"

  autoscaling_min_capacity = var.autoscaling_range["min_capacity"]
  autoscaling_max_capacity = var.autoscaling_range["max_capacity"]

  container_definitions = module.wordpress-container.container_definition

  load_balancer = {
    target_group_arn = "${var.alb_target_group_id}"
    container_name   = "wordpress"
    container_port   = 80
  }

  subnet_ids = var.wordpress_subnet_ids

  create_security_group = false
  security_group_ids = []

  task_exec_secret_arns = []
  task_exec_ssm_param_arns = []

  volume = {
    name = "wordpress-data"
    efs_volume_configuration = {
      file_system_id = "${var.efs_id}"
    }
  }
    
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

  }

# Configuration du conteneur wordpress exécuté dans chaque Task
module "wordpress-container" {
  source  = "terraform-aws-modules/ecs/aws//modules/container-definition"
  version = "5.10.0"

  name      = "wordpress"
  essential = true
  image     = "${var.wordpress_image["repo_url"]}:${var.wordpress_image["image_tag"]}"
  environment = [
    {
        name = "WORDPRESS_DB_HOST"
        value = "${var.rds_database["db_hostname"]}"
    },
    {
        name = "WORDPRESS_DB_USER"
        value = "${var.rds_database["db_username"]}"
    },
    {
        name = "WORDPRESS_DB_PASSWORD"
        value = "${var.rds_database["db_password"]}"
    },
    {
        name = "WORDPRESS_DB_NAME"
        value = "${var.rds_database["db_name"]}"
    }
  ]
  port_mappings = [
    {
      name          = "http"
      containerPort = 80
      protocol      = "tcp"
    },
    {
      name          = "https"
      containerPort = 443
      protocol      = "tcp"
    }
  ]

  # Il faudra vérifier si l'image wordpress requiert l'accès en écriture au root filesystem
  # readonly_root_filesystem = false

  mount_points = [
    {
    containerPath = "/var/www/web"
    sourceVolume  = "wordpress-data"
    }
  ]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

}