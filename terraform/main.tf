module "networking" {
  source = "./modules/networking"
  env    = var.env
  azs    = var.azs
}

module "security_group" {
  source         = "./modules/security_group"
  vpc_id         = module.networking.vpc_id
  vpc_cidr_block = module.networking.vpc_cidr_block
}

module "rds" {
  source            = "./modules/database_rds"
  vpc_db_group      = module.networking.database_subnet_group
  security_group_id = module.security_group.security_group_id
  encryption_key    = var.encryption_key
}

module "ecs" {
  source                     = "./modules/ecs"
  env                        = var.env
  capacity_provider_strategy = var.fargate_capacity_provider_strategy
  alb_target_group_id        = "" # A faire: ajouter la sortie du module alb
  autoscaling_range          = var.ecs_autoscaling_range
  wordpress_subnet_ids       = module.networking.wordpress_subnet_ids
  efs_id                     = "" # A faire: ajouter la sortie du module efs
  wordpress_image            = var.wordpress_image
  rds_database = {
    db_address  = module.rds.db_address
    db_username = var.db_username
    db_password = var.db_password
    dn_name     = module.rds.db_name
  }

}
