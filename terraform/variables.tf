variable "env" {
  type    = string
  default = "dev"
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b"]
}