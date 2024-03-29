# AWS Provider in backup region (us-east-1)
provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
  alias   = "backup"
}

# Creation of an IAM role with the default managed IAM Policy for allowing AWS Backup to create backups
data "aws_iam_policy_document" "backup_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "${var.env}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role_policy.json
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "backup_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = "${aws_iam_role.backup_role.name}"
} 

# Configuration of a backup vault in backup region (provider aws.backup)
resource "aws_backup_vault" "backup_vault" {
  name        = "${var.env}-backup-vault"
  force_destroy = true
  provider = aws.backup                # The vault is created in backup region using the backup aws provider
  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}

# Configuration of the backup plan
resource "aws_backup_plan" "backup_plan" {
  name = "${var.env}-backup-plan"

  rule {
    rule_name         = "${var.env}-backup-rule"
    target_vault_name = "${aws_backup_vault.backup_vault.name}"
    schedule          = "cron(0 3 * * ? *)"

    lifecycle {
      cold_storage_after = 30
      delete_after = 90
    }
  }
}

# Selection of the resources to be backup up: RDS database and EFS wordpress shared storage
resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${var.env}-backup-selection"
  plan_id      = aws_backup_plan.backup_plan.id

  resources = [
    var.rds_db_arn,          # RDS Wordpress database
    var.efs_arn,             # Wordpress EFS shared storage
    # var.s3_bucket_arn        # Wordpress static content s3 bucket
  ]
}