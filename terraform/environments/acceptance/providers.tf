#--------------------------------------------------------------
# Terraform Providers
#--------------------------------------------------------------

terraform {
  required_version = ">= 0.14"

  required_providers {
    aws        = ">= 3.22"
    helm       = ">= 1.3"
    local      = ">= 1.2"
    null       = ">= 2.1"
    template   = ">= 2.2"
    kubernetes = ">= 1.13"
  }
}

provider "aws" {
  region = var.region
}

provider "local" {
}

provider "null" {
}

provider "template" {
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}
