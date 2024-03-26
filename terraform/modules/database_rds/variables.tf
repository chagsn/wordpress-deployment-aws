variable "env" {
  description = "Deployment environment: dev or prod"
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
  description = "Id of the database instance security group"
  type = string
}