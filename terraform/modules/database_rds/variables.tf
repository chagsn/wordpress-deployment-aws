variable "db_name" {
  type = string
  description = "Name of the database to create"
}

variable "db_username" {
  type = string
  description = "Username for the master DB user"
}

variable "db_password" {
  type = string
  description = "Password for the master DB user"
}

variable "vpc_db_group" {
  description = "Name of database subnet group"
  type = string
}

variable "security_group_id" {
  description = "Id of the database instance security group"
  type = string
}