variable "db_name" {
  type = string
  description = "This is the name of the rds database"
  default = "WP_DB"
}

variable "vpc_db_group" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}