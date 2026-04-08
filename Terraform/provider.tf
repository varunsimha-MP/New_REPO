terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

provider "aws" {
    region = var.app_region
    assume_role {
      role_arn = "arn:aws:iam::1234567890xxx:role/TerraformRole"
      session_name = "terraform"
    }
}
