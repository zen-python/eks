data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.47.0"

  name                 = "test-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

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
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  worker_groups = [
      {
        instance_type = "t3.small"
        asg_max_size  = 2
        root_volume_size = 32
        root_volume_type = "gp2"
        root_encrypted = true
        root_kms_key_id = module.kms_key.key_arn
        workers_additional_policies = [module.alb_ingress.alb_iam_role_arn]
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
}

module "alb_ingress" {
  source = "../../modules/eks-alb-ingress"

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

