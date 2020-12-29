variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

variable "enabled" {
  type = bool
}

variable "helm_chart_name" {
  default = "aws-load-balancer-controller"
}

variable "helm_chart_version" {
  default = "1.1.1"
}

variable "helm_release_name" {
  default = "aws-load-balancer-controller"
}

variable "helm_repo_url" {
  default = "https://aws.github.io/eks-charts"
}

variable "k8s_namespace" {
  default     = "kube-system"
  description = "The k8s namespace in which the alb-ingress service account has been created"
}

variable "k8s_service_account_name" {
  default     = "aws-alb-ingress-controller"
  description = "The k8s alb-ingress service account name"
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/incubator/aws-alb-ingress-controller"
}
