# This file orchestrates the overall Terraform configuration by including other configuration files.
# Include provider configuration
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
 }
}

provider "aws" {
 region     = var.aws_region
 access_key = var.aws_access_key
 secret_key = var.aws_secret_key
}

######################################################################
###################Following are optional#############################
######################################################################

# Include infrastructure configuration
module "infra" {
 source = "./infra"
}
# Include web tier configuration
module "web_tier" {
 source = "./web_tier"
}
# Include db tier configuration
module "db_tier" {
 source = "./db_tier"
}
