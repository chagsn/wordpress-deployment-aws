output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "publics_subnet_ids" {
  value = module.vpc.public_subnets
}
output "wordpress_subnet_ids" {
  value = module.vpc.private_subnets
}
output "database_subnet_group" {
  value = module.vpc.database_subnet_group_name
}