# Configuration du VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.env}-vpc"
  cidr = "10.0.0.0/16"
  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_names = ["private_subnet1", "private_subnet2"]
  
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_names = ["public_subnet1", "public_subnet2"]

  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
  database_subnet_names = ["DB_subnet1", "DB_subnet2"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
#    Name = "${var.env}-vpc"
    Terraform = "true"
    Environment = "${var.env}"
  }
}
