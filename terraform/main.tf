module "networking" {
  source = "./modules/networking"
  env    = var.env
  azs    = var.azs
}

module "security_group" {
  source = "./modules/security_group"
  env    = var.env
  vpc_id = module.networking.vpc_id
}

module "rds" {
  source            = "./modules/database_rds"
  vpc_db_group      = module.networking.database_subnet_group
  security_group_id = module.security_group.db_security_group_id
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

module "ecs" {
  source                     = "./modules/ecs"
  env                        = var.env
  capacity_provider_strategy = var.fargate_capacity_provider_strategy
  alb_target_group_id        = "" # A faire: ajouter la sortie du module alb
  autoscaling_range          = var.ecs_autoscaling_range
  wordpress_subnet_ids       = module.networking.wordpress_subnet_ids
  security_group_id          = module.security_group.ecs_security_group_id
  efs_id                     = "" # A faire: ajouter la sortie du module efs
  wordpress_image            = var.wordpress_image
  rds_database = {
    db_address  = module.rds.db_address
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  }

}
