terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cato = {
      source = "catonetworks/cato"
    }
  }
  required_version = ">= 0.13"
}