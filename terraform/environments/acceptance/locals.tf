locals {
  cluster_name                  = "acceptance"
  env                           = "production"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler"
  dns_base_domain               = "aws-eks.be"
  services_subdomains = ["sample", "api"]
}
