#--------------------------------------------------------------
# Main VPC / Cluster / Ingress
#--------------------------------------------------------------
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name                 = "acceptance-vpc"
  cidr                 = "10.1.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets       = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks_cluster" {
  source          = "../../modules/aws-eks"
  cluster_name    = local.cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  tags = {
    Environment = "acceptance"
    IACTool     = "Terraform"
  }

  worker_groups = [
    {
      instance_type        = "t3.small"
      asg_desired_capacity = 1
      asg_max_size         = 2
      root_volume_size     = 100
      root_volume_type     = "gp2"
      root_encrypted       = true
      root_kms_key_id      = module.kms_key.key_arn

      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "true"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "true"
          "value"               = "true"
        }
      ]
    }
  ]
  workers_additional_policies = [module.alb_ingress.iam_policy_arn]
}

module "alb_ingress" {
  source = "../../modules/alb-ingress"

  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn
  cluster_name                     = local.cluster_name

  enabled = true

  settings = {
    "awsVpcID" : module.vpc.vpc_id
    "awsRegion" : var.region
  }
}

# #aws-eks.be
# module "acm_aws_eks_be" {
#   source      = "../../modules/acm-certificate"
#   domain_name = "*.aws-eks.be"

#   subject_alternative_names = [
#     "aws-eks.be"
#   ]

#   tags = {
#     Confidential = "no"
#     IACTool      = "Terraform"
#   }
# }
