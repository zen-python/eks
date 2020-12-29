provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "eks_terraform_state" {
  bucket = "no-ops-eks-terraform-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name        = "eks-terraform-state"
    Environment = "production"
  }
}

resource "aws_dynamodb_table" "eks_terraform_locks" {
  name         = "eks-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "eks-terraform-locks"
    Environment = "production"
  }
}
