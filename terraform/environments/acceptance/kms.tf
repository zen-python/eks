#--------------------------------------------------------------
# KMS key to encrypt credentials / volumes
#--------------------------------------------------------------
module "kms_key" {
  source = "../../modules/kms"

  policy_template_path = "../../modules/kms/templates/kms-key-policy.tpl"

  policy_template_vars = {
    account_id     = lookup(var.account_ids, local.env)
  }

  description         = "KMS key for environment ${local.env}"
  is_enabled          = true
  enable_key_rotation = true

  tags = {
    Confidential = "yes"
    IACTool      = "Terraform"
  }

  alias = "alias/eks-${local.env}/kms"
}
