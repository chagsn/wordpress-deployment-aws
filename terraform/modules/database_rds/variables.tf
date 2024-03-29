variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "db_engine" {
  description = "Engine configuration for the database:{engine,engine_version,family,major_engine_version}"
  type = map(string)
}

variable "db_instance_class" {
  description = "Instance class of the database"
  type = string
}

variable "db_storage_sizing" {
  description = "Storage sizing of the database"
  type = map(number)
}

variable "db_maintenance_window" {
  description = "Window to perform database maintenance"
  type = string
}

variable "db_name" {
  description = "Name of the RDS database"
  type = string
}

variable "db_username" {
  description = "Username of the RDS database"
  type = string
}

variable "db_password_automatic_rotation_schedule" {
  description = "Number of days between automatic scheduled rotations of the secret containing the DB password"
  type = number
}

variable "vpc_db_group" {
  description = "Name of database subnet group"
  type = string
}

variable "security_group_id" {
  description = "ID of the database instance security group"
  type = string
}