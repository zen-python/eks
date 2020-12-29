#--------------------------------------------------------------
# External Secrets  IRSA
#--------------------------------------------------------------
module "iam_assumable_role_admin_external_secrets" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "external-secrets-${local.cluster_name}"
  provider_url                  = replace(module.eks_cluster.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_secrets.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.external_secrets_sa_name}"]
}

resource "aws_iam_policy" "external_secrets" {
  description = "EKS external-secrets policy for cluster ${module.eks_cluster.cluster_id}"
  name        = "external-secrets-${local.cluster_name}"
  policy      = data.aws_iam_policy_document.external_secrets.json
}

data "aws_iam_policy_document" "external_secrets" {
  statement {
    sid    = "AllowParameterStoreGets"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSecretsGets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["*"]
  }
}
