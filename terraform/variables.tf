variable "env" {
  type    = string
  default = "dev"
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}

variable "encryption_key" {
  type = string
  default = "arn:aws:kms:eu-west-3:962480255828:key/66c16fcc-ea7f-4aca-8dc1-8ecab3477e49"
}