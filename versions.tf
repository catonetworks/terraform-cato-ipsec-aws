terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cato = {
      source  = "catonetworks/cato"
      version = ">= 0.0.30"
    }
  }
  required_version = ">= 1.5"
}