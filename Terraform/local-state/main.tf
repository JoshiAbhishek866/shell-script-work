# main.tf
terraform {
  backend "s3" {
    encrypt = true
  }
}

# example of 'partial configuration':
# https://www.terraform.io/docs/backends/config.html#partial-configuration
#
# cat config/backend-dev.conf
bucket  = "<account_id>-terraform-states"
key     = "development/service-name.tfstate"
encrypt = true
region  = "ap-southeast-2"
dynamodb_table = "terraform-lock"
