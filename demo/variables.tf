variable "aws_region" {
 default = "us-east-1" # North Virginia region
}
variable "vpc_cidr" {
 default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
 default = "10.0.1.0/24"
}
variable "private_subnet_cidr_a" {
 default = "10.0.2.0/24"
}
variable "private_subnet_cidr_b" {
 default = "10.0.3.0/24"
}
variable "ec2_ami" {
 default = "ami-0ba9883b710b05ac6" # Amazon Linux 2 AMI
}
variable "instance_type" {
 default = "t2.micro"
}
variable "db_instance_class" {
 default = "db.r5.large"
}
variable "db_name" {
 default = "demo_db"
}
variable "db_engine" {
 default = "aurora-mysql"
}