# Defining environment: local variable "env" is set to terraform.wokspace if value is in allowed environment values, 
#                       else set to "dev" by default
locals {
  env = contains(var.allowed_env, terraform.workspace) ? terraform.workspace : "dev"
}


module "networking" {
  source                 = "./modules/networking"
  env                    = local.env
  azs                    = var.azs
  vpc_cidr               = lookup(var.vpc_cidr, local.env)
  public_subnets_cidr    = lookup(var.public_subnets_cidr, local.env)
  wordpress_subnets_cidr = lookup(var.wordpress_subnets_cidr, local.env)
  database_subnets_cidr  = lookup(var.database_subnets_cidr, local.env)
}

module "security_group" {
  source                = "./modules/security_group"
  env                   = local.env
  vpc_id                = module.networking.vpc_id
  efs_security_group_id = module.efs.efs_security_group_id
}

module "alb" {
  source                = "./modules/alb"
  env                   = local.env
  vpc_id                = module.networking.vpc_id
  public_subnets_ids    = module.networking.publics_subnet_ids
  alb_security_group_id = module.security_group.alb_security_group_id
  health_check_path     = var.alb_health_check_path
}

module "ecs" {
  source                     = "./modules/ecs"
  env                        = local.env
  capacity_provider_strategy = lookup(var.fargate_capacity_provider_strategy, local.env)
  alb_target_group_id        = module.alb.alb_target_group_id
  autoscaling_range          = lookup(var.ecs_autoscaling_range, local.env)
  wordpress_subnet_ids       = module.networking.wordpress_subnet_ids
  security_group_id          = module.security_group.ecs_security_group_id
  efs_id                     = module.efs.efs_id
  efs_arn                    = module.efs.efs_arn
  wordpress_image            = var.wordpress_image
  containers_sizing          = lookup(var.wordpress_containers_sizing, local.env)
  rds_db_data = {
    address             = module.rds.db_address
    username            = var.db_username
    password_secret_arn = module.rds.db_password_secret_arn
    db_name             = var.db_name
  }
}

module "efs" {
  source                = "./modules/efs"
  env                   = local.env
  vpc_id                = module.networking.vpc_id
  ecs_security_group_id = module.security_group.ecs_security_group_id
  wordpress_subnet_ids  = module.networking.wordpress_subnet_ids
}

module "rds" {

  source                                  = "./modules/database_rds"
  env                                     = local.env
  db_engine                               = var.db_engine
  db_instance_class                       = lookup(var.db_instance_class, local.env)
  db_storage_sizing                       = lookup(var.db_storage_sizing, local.env)
  db_maintenance_window                   = var.db_maintenance_window
  db_name                                 = var.db_name
  db_username                             = var.db_username
  db_password_automatic_rotation_schedule = var.db_password_automatic_rotation_schedule
  vpc_db_group                            = module.networking.database_subnet_group
  security_group_id                       = module.security_group.db_security_group_id
}

module "bucket" {
  source              = "./modules/bucket"
  env                 = local.env
  cloudfront_oai_arns = module.cloudfront.cloudfront_oai_arns
}

module "cloudfront" {
  source                 = "./modules/cloudfront"
  s3_logs_dns            = module.bucket.s3_logs_dns
  s3_wordpress_media_dns = module.bucket.s3_wordpress_media_regional_dns
  alb_dns_name           = module.alb.alb_dns_name
}

module "route53" {
  source         = "./modules/route53"
  domain_name    = var.domain_name
  cloudfront_dns = module.cloudfront.cloudfront_dns
  cloudfront_id  = module.cloudfront.cloudfront_id
  subdomain_name = var.subdomain_name
}

# module "backup" {
#   source        = "./modules/backup"
#   env           = local.env
#   backup_region = var.backup_region
#   rds_db_arn    = module.rds.db_arn
#   efs_arn       = module.efs.efs_arn
#   s3_bucket_arn = module.bucket.wordpress_bucket_arn
# }
