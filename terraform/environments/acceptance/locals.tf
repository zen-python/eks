locals {
  cluster_name                  = "acceptance"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler"
  dns_base_domain               = "aws-eks.be"
  ingress_gateway_chart_name    = "nginx-ingress"
  ingress_gateway_chart_repo    = "https://helm.nginx.com/stable"
  ingress_gateway_chart_version = "0.7.1"
  ingress_gateway_annotations = {
    "controller.service.httpPort.targetPort"                                                                    = "http",
    "controller.service.httpsPort.targetPort"                                                                   = "http",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"        = "http",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"               = "https",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout" = "60",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"                    = "elb"
  }
  deployments_subdomains = ["sample", "api"]
}
