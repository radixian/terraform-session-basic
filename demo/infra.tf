resource "aws_vpc" "demo_vpc" {
 cidr_block = var.vpc_cidr
 tags = {
   Name = "demo-vpc"
 }
}
resource "aws_subnet" "demo_plc_subnet" {
 vpc_id                  = aws_vpc.demo_vpc.id
 cidr_block              = var.public_subnet_cidr
 availability_zone       = "us-east-1a"
 map_public_ip_on_launch = true
 tags = {
   Name = "demo-public-subnet"
 }
}
resource "aws_subnet" "demo_pvt_subnet_a" {
 vpc_id     = aws_vpc.demo_vpc.id
 cidr_block = var.private_subnet_cidr_a
 availability_zone       = "us-east-1a"
 tags = {
   Name = "demo-private-subnet-a"
 }
}
resource "aws_subnet" "demo_pvt_subnet_b" {
 vpc_id     = aws_vpc.demo_vpc.id
 cidr_block = var.private_subnet_cidr_b
 availability_zone       = "us-east-1b"
 tags = {
   Name = "demo-private-subnet-b"
 }
}
resource "aws_internet_gateway" "demo_igw" {
 vpc_id = aws_vpc.demo_vpc.id

 tags = {
   Name = "demo-igw"
 }
}
resource "aws_route_table" "demo_routetable" {
 vpc_id = aws_vpc.demo_vpc.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.demo_igw.id
 }
 tags = {
   Name = "demo-route-table"
 }
}
resource "aws_route_table_association" "demo_routetable_assoc" {
 subnet_id      = aws_subnet.demo_plc_subnet.id
 route_table_id = aws_route_table.demo_routetable.id
}
resource "aws_security_group" "demo_web_sg" {
 vpc_id = aws_vpc.demo_vpc.id

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
   Name = "demo-web-sg"
 }
}
resource "aws_security_group" "demo_db_sg" {
 vpc_id = aws_vpc.demo_vpc.id

 ingress {
   from_port   = 3306
   to_port     = 3306
   protocol    = "tcp"
   cidr_blocks = [aws_subnet.demo_plc_subnet.cidr_block, aws_vpc.demo_vpc.cidr_block, "0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
   Name = "demo-db-sg"
 }
}