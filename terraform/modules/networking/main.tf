# Configuration du VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.env}-vpc"
  cidr = var.vpc_cidr
  azs             = var.azs

  # Create public subnet in each AZ
  public_subnets  = var.public_subnets_cidr
  public_subnet_names = ["public_subnet1", "public_subnet2"]

  # Create private subnet for wordpress instances in each AZ
  private_subnets = var.wordpress_subnets_cidr
  private_subnet_names = ["wordpress_subnet1", "wordpress_subnet2"]
  
  # Create private subnet for RDS instances in each AZ
  database_subnets = var.database_subnets_cidr
  database_subnet_names = ["DB_subnet1", "DB_subnet2"]

  # Create one NAT gateway public subnet of each AZ
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  # Disable default security group creation
  manage_default_security_group = false

  tags = {
#    Name = "${var.env}-vpc"
    Terraform = "true"
    Environment = "${var.env}"
  }
}
