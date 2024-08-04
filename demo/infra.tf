resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
 tags = {
   Name = "main-vpc"
 }
}
resource "aws_subnet" "public" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = var.public_subnet_cidr
 map_public_ip_on_launch = true
 tags = {
   Name = "public-subnet"
 }
}
resource "aws_subnet" "private" {
 vpc_id     = aws_vpc.main.id
 cidr_block = var.private_subnet_cidr
 tags = {
   Name = "private-subnet"
 }
}
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "main-igw"
 }
}
resource "aws_route_table" "public" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 tags = {
   Name = "public-route-table"
 }
}
resource "aws_route_table_association" "public" {
 subnet_id      = aws_subnet.public.id
 route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "web_sg" {
 vpc_id = aws_vpc.main.id
 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
   Name = "web-sg"
 }
}
resource "aws_security_group" "db_sg" {
 vpc_id = aws_vpc.main.id
 ingress {
   from_port   = 3306
   to_port     = 3306
   protocol    = "tcp"
   cidr_blocks = [aws_subnet.public.cidr_block]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
   Name = "db-sg"
 }
}
