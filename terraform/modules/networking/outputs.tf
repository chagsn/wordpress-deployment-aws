output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "database_subnet_group" {
  value = module.vpc.database_subnet_group_name
}