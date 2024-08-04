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

######################################################################
###################Following are non-mandatory########################
######################################################################

provider "aws" {
 region = var.aws_region
}
# Include variables
variable "aws_region" {
 description = "The AWS region to deploy resources in."
 default     = "us-east-1" # North Virginia region
}


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
