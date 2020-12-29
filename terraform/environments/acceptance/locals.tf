#--------------------------------------------------------------
# Local variables
#--------------------------------------------------------------
locals {
  cluster_name                  = "acceptance"
  env                           = "production"
  k8s_service_account_namespace = "kube-system"
  cluster_autoscaler_sa_name    = "cluster-autoscaler"
  external_secrets_sa_name      = "external-secrets"
  dns_base_domain               = "aws-eks.be"
  services_subdomains           = ["sample", "api"]
}
