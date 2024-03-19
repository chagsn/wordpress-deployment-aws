variable "db_name" {
  type = string
  description = "This is the name of the rds database"
  default = "wordpressdb"
}

variable "vpc_db_group" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "encryption_key" {
  type = string
}