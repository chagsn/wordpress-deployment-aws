output "backup_vault_name" {
  description = "Name oh the backup vault"
  value = "${aws_backup_vault.backup_vault.id}"
}
