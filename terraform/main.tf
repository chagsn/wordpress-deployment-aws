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