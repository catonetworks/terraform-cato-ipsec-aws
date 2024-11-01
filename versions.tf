terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cato = {
      source  = "registry.terraform.io/catonetworks/cato"
      version = "~> 0.0.8"
    }
  }
  required_version = ">= 0.13"
}