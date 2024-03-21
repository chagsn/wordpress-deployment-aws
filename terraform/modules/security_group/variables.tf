variable "tag" {
  type        = string
  description = "Cette variable me permet de définir un tag à utiliser pour le SG"
  default     = ""
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}