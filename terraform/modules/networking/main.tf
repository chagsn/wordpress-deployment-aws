# Configuration du VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.env}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  # Create public subnet in each AZ
  public_subnets  = var.public_subnets_cidr
  public_subnet_names = ["${var.env}-public_subnet1", "${var.env}-public_subnet2"]

  # Create private subnet for wordpress instances in each AZ
  private_subnets = var.wordpress_subnets_cidr
  private_subnet_names = ["${var.env}-wordpress_subnet1", "${var.env}-wordpress_subnet2"]
  
  # Create private subnet for RDS instances in each AZ
  database_subnets = var.database_subnets_cidr
  database_subnet_names = ["${var.env}-DB_subnet1", "${var.env}-DB_subnet2"]

  # Create one NAT gateway public subnet of each AZ
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  # Disable default security group creation
  manage_default_security_group = false

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}
