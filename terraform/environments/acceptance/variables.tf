#--------------------------------------------------------------
# Default variables
#--------------------------------------------------------------

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "account_ids" {
  type = map(string)
  default = {
    production = "214402802177"
  }
}
