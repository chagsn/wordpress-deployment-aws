#Création et configuration AWS RDS Mysql
module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "6.5.4"
  identifier = var.db_name

  engine                 = "mysql"
  engine_version         = "8.0"
  family                 = "mysql8.0"
  major_engine_version   = "8.0"
  instance_class         = "db.t2.small"

  allocated_storage      = 20
  max_allocated_storage  = 100

  db_name  = var.db_name
  username = var.db_username
  # Pour l'instant on ne crée pas le password dans Secret Manager, à modifier ultérieurement
  manage_master_user_password = false
  password = var.db_password
  
  port     = 3306

  iam_database_authentication_enabled = true

  # No encryption of the database
  storage_encrypted = false

  # Multi-AZ configuration
  multi_az               = true

  # DB subnet group
  db_subnet_group_name   = var.vpc_db_group
  vpc_security_group_ids = [var.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-06:00"

  # CloudWatch logs
  # enabled_cloudwatch_logs_exports = ["general"]
  # create_cloudwatch_log_group     = true

  # Enhanced Monitoring - see example for details on how to create the role
  # monitoring_interval = "60"
  # monitoring_role_name   = "MyRDSMonitoringRole"
  # create_monitoring_role = true

  # No creation of snapshot before deleting
  skip_final_snapshot = true

  # Disable database Deletion Protection
  deletion_protection = false


  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  # options = [
  #   {
  #     option_name = "MARIADB_AUDIT_PLUGIN"

  #     option_settings = [
  #       {
  #         name  = "SERVER_AUDIT_EVENTS"
  #         value = "CONNECT"
  #       },
  #       {
  #         name  = "SERVER_AUDIT_FILE_ROTATIONS"
  #         value = "37"
  #       },
  #     ]
  #   },
  # ]

}