terraform {

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
  }

  backend "s3" {
    bucket = "gustavocosta-terraform-remote-state"
    key    = "poc_nrt/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  default_tags {
    tags = {
      owner      = "poc_nrt"
      managed-by = "terraform"
    }
  }
}
