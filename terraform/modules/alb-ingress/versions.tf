terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws   = "< 5.9"
    local = "~> 2.0"
    helm  = "< 2.10.2"
    null  = "~> 3.0"
  }
}
