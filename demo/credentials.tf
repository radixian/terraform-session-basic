provider "aws" {
 region     = var.aws_region
 access_key = var.aws_access_key
 secret_key = var.aws_secret_key
}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "db_username" {}
variable "db_password" {}
