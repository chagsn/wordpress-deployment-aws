output "alb_target_group_id" {
  value = module.alb.target_groups["wordpress-tg"].id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}