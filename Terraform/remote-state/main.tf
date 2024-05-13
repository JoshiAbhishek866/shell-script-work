terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-02f180f6f965cff84"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform_Demo"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "928731357842-terraform-states"  # Replace with your AWS account ID
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "928731357842-terraform-states"  # Replace with your AWS account ID
    key            = "development/service-name.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
