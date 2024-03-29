output "backup_vault_name" {
  description = "Name of the backup vault"
  value = "${aws_backup_vault.backup_vault.id}"
}
