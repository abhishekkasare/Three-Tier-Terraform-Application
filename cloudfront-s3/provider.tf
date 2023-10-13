
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.1"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_config_files      = ["/home/ubuntu/.aws/config"]
  shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
  profile                  = "default"
}

