output "db_security_group_id" {
  value = aws_security_group.db_security_group.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "ecs_security_group_id" {
   value = aws_security_group.ecs_security_group.id
}

output "efs_security_group_id" {
   value = aws_security_group.efs_security_group.id
}