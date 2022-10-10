terraform {
  # https://www.terraform.io/downloads.html
  required_version = "1.3.2"
} 

required_providers {
  # https://registry.terraform.io/providers/hashicorp/aws/latest
  aws = {
    source = "hashicorp/aws"
    version = "4.34.0"
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_default_region
}