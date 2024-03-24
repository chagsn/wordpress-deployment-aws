output "alb_target_group_id" {
  value = module.alb.target_groups["wordpress-tg"].id
}