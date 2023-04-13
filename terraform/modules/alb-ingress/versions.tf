terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws   = "< 4.62"
    local = "~> 2.0"
    helm  = "< 2.6.1"
    null  = "~> 2.0"
  }
}
