module "networking" {
  source                 = "./modules/networking"
  env                    = var.env
  azs                    = var.azs
  vpc_cidr               = var.vpc_cidr
  public_subnets_cidr    = var.public_subnets_cidr
  wordpress_subnets_cidr = var.wordpress_subnets_cidr
  database_subnets_cidr  = var.database_subnets_cidr
}

module "security_group" {
  source                = "./modules/security_group"
  env                   = var.env
  vpc_id                = module.networking.vpc_id
  efs_security_group_id = module.efs.efs_security_group_id
}

module "alb" {
  source                = "./modules/alb"
  env                   = var.env
  vpc_id                = module.networking.vpc_id
  public_subnets_ids    = module.networking.publics_subnet_ids
  alb_security_group_id = module.security_group.alb_security_group_id
}

module "ecs" {
  source                     = "./modules/ecs"
  env                        = var.env
  capacity_provider_strategy = var.fargate_capacity_provider_strategy
  alb_target_group_id        = module.alb.alb_target_group_id
  autoscaling_range          = var.ecs_autoscaling_range

  # wordpress_subnet_ids       = module.networking.wordpress_subnet_ids
  # Test
  wordpress_subnet_ids = module.networking.publics_subnet_ids
  security_group_id    = module.security_group.ecs_security_group_id
  efs_id               = module.efs.efs_id
  wordpress_image      = var.wordpress_image
  rds_database = {
    db_address  = module.rds.db_address
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  }
}

module "efs" {
  source                = "./modules/efs"
  env                   = var.env
  vpc_id                = module.networking.vpc_id
  ecs_security_group_id = module.security_group.ecs_security_group_id
  wordpress_subnet_ids  = module.networking.wordpress_subnet_ids
}

module "rds" {
  source            = "./modules/database_rds"
  vpc_db_group      = module.networking.database_subnet_group
  security_group_id = module.security_group.db_security_group_id
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

