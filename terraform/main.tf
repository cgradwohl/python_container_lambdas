terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    encrypt = true
    assume_role = {
      role_arn = "value"
    }
  }
}
