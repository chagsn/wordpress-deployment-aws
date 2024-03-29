output "vpc_id" {
  description = "ID of the created VPC"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR"
  value = module.vpc.vpc_cidr_block
}

output "nat_public_ips" {
  description = "Public IPs of the NAT Gateways (one NAT GW in each public subnet)"
  value = module.vpc.nat_public_ips
}

output "publics_subnet_ids" {
  description = "List of public subnets IDs"
  value = module.vpc.public_subnets
}
output "wordpress_subnet_ids" {
  description = "List of wordpress instances private subnets IDs"
  value = module.vpc.private_subnets
}
output "database_subnet_group" {
  description = "Name of the subnet group for database instance"
  value = module.vpc.database_subnet_group_name
}