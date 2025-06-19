terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sumedh-org"
    workspaces {
      prefix = "expense-diary-"
    }
  }
  required_version = "~> 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
  # assume_role {
  #   role_arn = var.AWS_ROLE_ARN
  # }
  default_tags {
    tags = {
      ManagedBy  = "Sumedh Shakya"
      Management = "terraform"
    }
  }
}