output "alb_target_group_id" {
  description = "ID of the ALB target group"
  value = module.alb.target_groups["wordpress-tg"].id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value = module.alb.dns_name
}

output "alb_id" {
  description = "ID of ALB"
  value = module.alb.zone_id
}