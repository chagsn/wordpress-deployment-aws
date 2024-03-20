module "networking" {
  source = "./modules/networking"
  env    = var.env
  azs    = var.azs
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.networking.vpc_id
  vpc_cidr_block = module.networking.vpc_cidr_block
}

module "rds" {
  source = "./modules/database_rds"
  vpc_db_group = module.networking.database_subnet_group
  security_group_id = module.security_group.security_group_id
  encryption_key = var.encryption_key
}