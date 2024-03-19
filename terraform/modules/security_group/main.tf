# Fichier de création et de configuration de tous les security group

# Création et configuration du security group de la base de données
module "db_security_group" {
    source = "terraform-aws-modules/security-group/aws"

    name = "rds_sgp"
    description = "RDS mysql security group"
    vpc_id = var.vpc_id

    #ingress
    ingress_with_cidr_blocks = [
        {
            from_port = 3306
            to_port   = 3306
            protocol  = "tcp"
            description = "Mysql access from within VPC"
            cidr_blocks = var.vpc_cidr_block
        }
    ]
}

