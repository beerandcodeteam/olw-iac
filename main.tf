terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.0.0"
    }
  }

  required_version = "~> 1.3.3"
}

provider "aws" {
    region = var.AWS_REGION
    shared_config_files = ["./.aws/credentials"]
}

data "aws_availability_zones" "available" {
    state = "available"
}
