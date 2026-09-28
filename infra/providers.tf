terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "tech-nova-tf-state-devops-2026-maximus"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tech-nova-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "TechNova-API"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}
