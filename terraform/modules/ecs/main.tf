# Local variable: EFS-storage volume name
locals {
  efs_volume_name = "wordpress-efs-volume"
}

# Configuration du cluster ECS
module "wordpress-cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.10.0"

  cluster_name = "${var.env}-wordpress-cluster"
  
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

# Création d'une policy pour le Task role autorisant le montage des mount targets de l'EFS
resource "aws_iam_policy" "task_role_mountefs_policy" {
  description = "Allows to mount EFS mount targets and access to file system root"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticfilesystem:ClientRootAccess",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientMount"
        ]
        Effect   = "Allow"
        Resource = "${var.efs_arn}"
      }
    ]
  })
}

# Configuration du service ECS déployant les Tasks
module "wordpress-service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.10.0"

  name        = "${var.env}-wordpress-service"
  cluster_arn = module.wordpress-cluster.id

  # CPU and memeory sizing
  cpu    = 1024
  memory = 4096

  # Autoscaling configuration
  autoscaling_min_capacity = var.autoscaling_range["min_capacity"]
  autoscaling_max_capacity = var.autoscaling_range["max_capacity"]

  # Adding Secrets manager permissions to the task execution role to allow to get/read RDS database password
  task_exec_secret_arns = [var.rds_db_data["password_secret_arn"]]
  
  # Adding EFS mounting permissions to the default task role created by Terraform
  tasks_iam_role_policies = {
    efsmounting = "${aws_iam_policy.task_role_mountefs_policy.arn}"
  }
  
  # Taking into account task definition changes
  ignore_task_definition_changes = false

  # Enabling Exec command to be able to execute commands on containers in dev environment only
  enable_execute_command = var.env=="dev" ? true : false

  # Container definition
  container_definitions = {
    wordpress = {
      name = "${var.env}-wordpress-container"
      essential = true
      image     = "${var.wordpress_image["repo_url"]}:${var.wordpress_image["image_tag"]}"
      environment = [
        {
            name = "WORDPRESS_DB_HOST"
            value = "${var.rds_db_data["address"]}"
        },
        {
            name = "WORDPRESS_DB_USER"
            value = "${var.rds_db_data["username"]}"
        },
        {
            name = "WORDPRESS_DB_NAME"
            value = "${var.rds_db_data["db_name"]}"
        }
      ]
      secrets = [
        {
            name = "WORDPRESS_DB_PASSWORD"
            valueFrom = "${var.rds_db_data["password_secret_arn"]}:password::"
        }
      ]
      # health_check = {
      #   command = ["CMD-SHELL", "curl -f http://localhost:${local.container_port}/health || exit 1"]
      # }
      health_check = {
          # command = ["CMD-SHELL", "curl", "-f", "http://localhost:80 || exit 1"]
          command = ["CMD-SHELL", "curl -Lf http://localhost:80 || exit 1"]
          interval = 30
          timeout  = 15
          retries  = 3
      }
      port_mappings = [
        {
          name          = "http"
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      # Il faudra vérifier si l'image wordpress requiert l'accès en écriture au root filesystem
      readonly_root_filesystem = false  
      
      # Mounting points to EFS storage
      mount_points = [
        {
        containerPath = "/var/www/web"
        sourceVolume  = local.efs_volume_name
        readOnly      = false
        }
      ]
    }
  }

  # Attachement to load balancer target group
  load_balancer = {
    alb = {
      target_group_arn = var.alb_target_group_id
      container_name   = "${var.env}-wordpress-container"
      container_port   = 80
    }
  }
  # Load balancer health_checks configuration
  health_check_grace_period_seconds = 30

  # Network configuration
  network_mode = "awsvpc"
  subnet_ids = var.wordpress_subnet_ids
  create_security_group = false
  security_group_ids = [var.security_group_id]

  # EFS volume attachment configuration
  volume = [
    {
      name = local.efs_volume_name
      efs_volume_configuration = {
        file_system_id = var.efs_id
      }
    }
  ]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

  }