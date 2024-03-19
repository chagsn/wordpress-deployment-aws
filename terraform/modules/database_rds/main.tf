#Création et configuration AWS RDS Mysql
module "db" {
    source = "terraform-aws-modules/rds/aws"

    identifier = var.db_name

    engine                 = "mysql"
    engine_version         = "8.0"
    family                 = "mysql8.0"
    major_engine_version   = "8.0"
    instance_class         = "db.t2.small"

    allocated_storage      = 20
    max_allocated_storage  = 100

    db_name  = var.db_name
    username = "user"
    port     = 3306

    iam_database_authentication_enabled = true

    multi_az               = true
    db_subnet_group_name   = [var.vpc_db_group]
    vpc_security_group_ids = [var.security_group_id]
  
    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_window = "03:00-06:00"
    enabled_cloudwatch_logs_exports = ["general"]
    create_cloudwatch_log_group     = true

    monitoring_interval = "60"
    monitoring_role_name   = "MyRDSMonitoringRole"
    create_monitoring_role = true

    skip_final_snapshot = true
    deletion_protection = false

}