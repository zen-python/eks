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



