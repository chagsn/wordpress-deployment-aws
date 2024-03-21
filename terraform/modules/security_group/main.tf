# Local variables
# List of HTTP and HTTPS ports to open
locals {
  alb_sg_ports = ["80","443"]
}
# List of security group rule types
locals {
  rule_types = ["ingress","egress"]
}

# Configuration du security group pour l'ALB
resource "aws_security_group" "alb_security_group" {
  name        = "${var.env}-alb-sg"
  description = "Security group for ALB in ${var.env} environment"
  vpc_id      = var.vpc_id

  # Règles de trafic entrant: autorisent tout trafic entrant en HTTP et HTTPS
  dynamic ingress {
    for_each = local.alb_sg_ports   # Boucle sur les ports à ouvrir en ingress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Règles de trafic sortant: autorisent le trafic sortant à destination du security group du service ECS wordpress en HTTP et HTTPS
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

/* Création du security group pour le service ECS wordpress
   Le security group est d'abord créé sans règles ingress et egress.
   On lui attachera des règles après création des différents services (ECS, ALB, EFS, RDS),
   pour éviter les 'circle errors'.
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


# Configuration du security group pour les points de montage du système de fichiers EFS
resource "aws_security_group" "efs_security_group" {
  name        = "${var.env}-efs-sg"
  description = "Security group for EFS in ${var.env} environment"
  vpc_id      = var.vpc_id

  # Règle de trafic entrant: autorise le trafic entrant en provenance du security group du service ECS wordpress en NFS
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  # Règle de trafic sortant: autorise le trafic sortant à destination du security group du service ECS wordpress en NFS
  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

# Configuration du security group pour la base de données RDS
resource "aws_security_group" "db_security_group" {
  name        = "${var.env}-db-sg"
  description = "Security group for RDS databse in ${var.env} environment"
  vpc_id      = var.vpc_id

  # Règle de trafic entrant: autorise le trafic entrant en provenance du security group du service ECS wordpress sur le port 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  # Règle de trafic sortant: autorise le trafic sortant à destination du security group du service ECS wordpress sur le port 3306
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

# Configuration des règles ingress et egress pour le security group du service ECS wordpress

# Autorisation du trafic avec l'ALB
resource "aws_security_group_rule" "ecs_sg_ingress_rule_alb" {
  description = "Security group ingress rules for ECS wordpress service: allow traffic FROM ALB"
  for_each = toset(local.alb_sg_ports)
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.alb_security_group.id
}

resource "aws_security_group_rule" "ecs_sg_egress_rule_alb" {
  description = "Security group egress rules for ECS wordpress service: allow traffic TO ALB"
  for_each = toset(local.alb_sg_ports)
  type              = "egress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.alb_security_group.id
}

# Autorisation du trafic avec l'EFS
resource "aws_security_group_rule" "ecs_sg_rules_efs" {
  description = "Security group rules for ECS wordpress service: : allow traffic from and to EFS"
  for_each = toset(local.rule_types)
  type              = each.key
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.efs_security_group.id
}

# Autorisation du trafic avec la base de données
resource "aws_security_group_rule" "ecs_sg_rules_rds" {
  description = "Security group rules for ECS wordpress service: : allow traffic from and to rds"
  for_each = toset(local.rule_types)
  type              = each.key
  from_port         = 3306
  to_port           = 23306
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.db_security_group.id
}

