variable "region" {
  default = "eu-west-1"
}

variable "account_ids" {
  type = map(string)
  default = {
    production          = "214402802177"
  }
}