output "db_security_group_id" {
  description = "ID of the RDS database instance security group"
  value = aws_security_group.db_security_group.id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value = aws_security_group.alb_security_group.id
}

output "ecs_security_group_id" {
  description = "ID of the ECS service security group"
   value = aws_security_group.ecs_security_group.id
}