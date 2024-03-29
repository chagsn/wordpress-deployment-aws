# Local variables
locals {
# List of HTTP and HTTPS ports to open
  alb_sg_ports = ["80","443"]
# List of security group rule types
  rule_types = ["ingress","egress"]
}

# Configuration of ALB security group
resource "aws_security_group" "alb_security_group" {
  name        = "${var.env}-alb-sg"
  description = "Security group for ALB in ${var.env} environment"
  vpc_id      = var.vpc_id

  # Inbound rules: allow inbound traffic from anywhere in HTTP and HTTPS    !!!TO BE MODIFIED!!!
  dynamic ingress {
    for_each = local.alb_sg_ports   # Loop over the ports to set accessible
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Outbound rules: allow outbound traffic to ECS service security group in HTTP and HTTPS
  dynamic egress {
    for_each = local.alb_sg_ports   # Boucle sur les ports à ouvrir en ingress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      security_groups = [aws_security_group.ecs_security_group.id]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

/* Creation of ECS service security group
   The security group is first created without any ingress nor egress rule.
   Rules will be added after the creation of the different services (ECS, ALB, EFS, RDS),
   so as to avoid Terraform 'circle errors'.
*/
resource "aws_security_group" "ecs_security_group" {
  name        = "${var.env}-ecs-sg"
  description = "Security group for ECS wordpress service in ${var.env} environment"
  vpc_id      = var.vpc_id

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

# Configuration of RDS database security group
resource "aws_security_group" "db_security_group" {
  name        = "${var.env}-db-sg"
  description = "Security group for RDS databse in ${var.env} environment"
  vpc_id      = var.vpc_id

  # Inbound rule: allow inboud traffic from ECS service security group on port 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  # Outbound rule: allow outbound traffic to ECS service security group on port 3306
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  # Outbound rule: allow outbound traffic to anywhere in HTTPS (to allow access to AWS APIs, e.g Cloudwatch)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

# Configuration of inbound and outbound rules for ECS service security group

# Inbound rule: allow inboud traffic from ALB in HTTP and HTTPS
resource "aws_security_group_rule" "ecs_sg_ingress_rule_alb" {
  description = "Security group ingress rules for ECS wordpress service: allow HTTP/HTTPS inbound traffic from ALB"
  for_each = toset(local.alb_sg_ports)
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.alb_security_group.id
}

# Outbound rule: allow outbound traffic to anywhere in HTTPS (to allow access to wordpress repo in ECR Public Gallery and AWS APIs)
resource "aws_security_group_rule" "ecs_sg_egress_rule_alb" {
  description = "Security group egress rules for ECS wordpress service: allow HTTP/HTTPS outbound traffic to anywhere"
  # for_each = toset(local.alb_sg_ports)
  type              = "egress"
  # from_port         = each.key
  from_port         = 443
  # to_port           = each.key
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Inbound and outbound rules: allow traffic from and to EFS on port 2049
resource "aws_security_group_rule" "ecs_sg_rules_efs" {
  description = "Security group rules for ECS wordpress service: : allow traffic from and to EFS"
  for_each = toset(local.rule_types)
  type              = each.key
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = var.efs_security_group_id
}

# Inbound and outbound rules: allow traffic from and to RDS database on port 3306
resource "aws_security_group_rule" "ecs_sg_rules_rds" {
  description = "Security group rules for ECS wordpress service: : allow traffic from and to RDS database"
  for_each = toset(local.rule_types)
  type              = each.key
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.db_security_group.id
}

