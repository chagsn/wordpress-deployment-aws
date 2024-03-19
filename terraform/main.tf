module "networking" {
  source = "./modules/networking"
  env    = var.env
  azs    = var.azs
}