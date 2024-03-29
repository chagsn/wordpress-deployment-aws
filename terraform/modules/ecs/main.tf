# Local variables: EFS-storage volume name
locals {
  # EFS-storage volume name
  efs_volume_name = "wordpress-efs-volume"
  # Container listening port
  container_port = 80
}

# Configuration of ECS cluster
module "wordpress-cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.10.0"

  cluster_name = "${var.env}-wordpress-cluster"
  
  # Capacity provider: Fargate
  default_capacity_provider_use_fargate = true
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = "${var.capacity_provider_strategy["FARGATE"]}"
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = "${var.capacity_provider_strategy["FARGATE_SPOT"]}"
      }
    }
  }

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

}

# Creation of a policy for the Task role allowing to mount EFS mount targets
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

# Configuration of ECS service
module "wordpress-service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.10.0"

  name        = "${var.env}-wordpress-service"
  cluster_arn = module.wordpress-cluster.id

  # CPU and memory sizing of the wordprress containers
  cpu    = var.containers_sizing["cpu"]
  memory = var.containers_sizing["memory"]

  # Autoscaling configuration
  autoscaling_min_capacity = var.autoscaling_range["min_capacity"]
  autoscaling_max_capacity = var.autoscaling_range["max_capacity"]

  # Adding Secrets manager permissions to the task execution role to allow to get/read RDS database password
  task_exec_secret_arns = [var.rds_db_data["password_secret_arn"]]
  
  # Adding EFS mounting permissions to the default Task role created by Terraform
  tasks_iam_role_policies = {
    efsmounting = "${aws_iam_policy.task_role_mountefs_policy.arn}"
  }
  
  # Taking into account task definition changes
  ignore_task_definition_changes = false

  # Enabling Exec command to be able to execute commands on containers in dev environment only
  enable_execute_command = var.env=="dev" ? true : false

  #############################################################################################
  # Container definition
  container_definitions = {
    wordpress = {
      name = "${var.env}-wordpress-container"
      essential = true
      image     = "${var.wordpress_image["repo_url"]}:${var.wordpress_image["image_tag"]}"

      # Environment variables to pass to the container
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

      # Secret to retrieve from Secrets Manager: database password 
      secrets = [
        {
            name = "WORDPRESS_DB_PASSWORD"
            valueFrom = "${var.rds_db_data["password_secret_arn"]}:password::"
        }
      ]

      # Health checks
      health_check = {
          command = ["CMD-SHELL", "curl -Lf http://localhost:${local.container_port} || exit 1"]
          interval = 30
          timeout  = 15
          retries  = 3
      }

      port_mappings = [
        {
          name          = "http"
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]

      # Il faudra vérifier si l'image wordpress requiert l'accès en écriture au root filesystem
      readonly_root_filesystem = false  
      
      # Mounting points to EFS volume
      mount_points = [
        {
        containerPath = "/var/www/web"
        sourceVolume  = "${local.efs_volume_name}"
        readOnly      = false
        }
      ]
    }
  }
 # Enf of container definition
 #############################################################################################

  # Attachement to load balancer target group
  load_balancer = {
    alb = {
      target_group_arn = "${var.alb_target_group_id}"
      container_name   = "${var.env}-wordpress-container"
      container_port   = local.container_port
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
      name = "${local.efs_volume_name}"
      efs_volume_configuration = {
        file_system_id = "${var.efs_id}"
      }
    }
  ]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

  }