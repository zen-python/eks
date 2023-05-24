terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws   = "< 4.68"
    local = "~> 2.0"
    helm  = "< 2.9.1"
    null  = "~> 3.0"
  }
}
