#--------------------------------------------------------------
# KMS variables
#--------------------------------------------------------------
variable "description" {
}

variable "enable_key_rotation" {
}

variable "tags" {
  type = map(string)
}

variable "alias" {
}

variable "key_usage" {
  default = "ENCRYPT_DECRYPT"
}

variable "is_enabled" {
  default = "true"
}

variable "deletion_window_in_days" {
  default = "30"
}

# Template variables
variable "policy_template_path" {
}

variable "policy_template_vars" {
  type = map(string)
}
