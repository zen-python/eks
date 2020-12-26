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

#--------------------------------------------------------------
# KMS key resources
#--------------------------------------------------------------
resource "aws_kms_key" "key" {
  description             = var.description
  enable_key_rotation     = var.enable_key_rotation
  policy                  = data.template_file.template.rendered
  tags                    = var.tags
  key_usage               = var.key_usage
  is_enabled              = var.is_enabled
  deletion_window_in_days = var.deletion_window_in_days
}

resource "aws_kms_alias" "alias" {
  name          = var.alias
  target_key_id = aws_kms_key.key.key_id
}

data "template_file" "template" {
  template = file(var.policy_template_path)
  vars     = var.policy_template_vars
}

#--------------------------------------------------------------
# Outputs
#--------------------------------------------------------------

output "key_arn" {
  value = aws_kms_key.key.arn
}

output "key_id" {
  value = aws_kms_key.key.id
}
