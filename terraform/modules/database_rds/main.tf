#Création et configuration AWS RDS Mysql

module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "6.5.4"

  identifier = "${var.env}-${var.db_name}"

  # Engine configuration
  engine                 = var.db_engine["engine"]
  engine_version         = var.db_engine["engine_version"]
  family                 = var.db_engine["family"]
  major_engine_version   = var.db_engine["major_engine_version"]
  
  # Database instance class
  instance_class         = var.db_instance_class

  # Database storage sizing
  allocated_storage      = var.db_storage_sizing["allocated_storage"]
  max_allocated_storage  = var.db_storage_sizing["max_allocated_storage"]

  # Database name, username and password
  db_name  = "${var.db_name}"
  username = "${var.db_username}"
  # Database password is created and managed by the present module
  manage_master_user_password = true
  manage_master_user_password_rotation = true
  master_user_password_rotation_automatically_after_days = var.db_password_automatic_rotation_schedule
  
  port     = 3306

  # No encryption
  storage_encrypted = false

  # Multi-AZ configuration
  multi_az = true

  # DB subnet group
  db_subnet_group_name   = var.vpc_db_group
  vpc_security_group_ids = [var.security_group_id]

  # Maintenance window
  maintenance_window = var.db_maintenance_window

  # CloudWatch monitoring
  enabled_cloudwatch_logs_exports = ["general"]
  create_cloudwatch_log_group     = true

  monitoring_interval = "60"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  # No creation of snapshot before deleting
  skip_final_snapshot = true

  # Disable database Deletion Protection
  deletion_protection = false

  # MySQL parameters: character set
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

  # Add MariaDB Audit plugin to record connections to database
  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }

}