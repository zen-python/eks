terraform {
  backend "s3" {
    bucket         = "no-ops-eks-terraform-state"
    key            = "acceptance/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "eks-terraform-locks"
  }
}
