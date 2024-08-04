provider "aws" {
 region = var.aws_region
}
resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
 tags = {
   Name = "main-vpc"
 }
}
resource "aws_subnet" "public" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.public_subnet_cidr
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
resource "aws_instance" "web" {
 ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
 instance_type = var.instance_type
 subnet_id     = aws_subnet.public.id
 security_groups = [aws_security_group.web_sg.name]
 user_data = <<-EOF
             #!/bin/bash
             yum update -y
             yum install -y httpd
             systemctl start httpd
             systemctl enable httpd
             echo "Hello, World from $(hostname -f)" > /var/www/html/index.html
             EOF
 tags = {
   Name = "web-instance"
 }
}
resource "aws_rds_cluster" "aurora" {
 cluster_identifier      = "aurora-cluster-demo"
 engine                  = "aurora-mysql"
 master_username         = var.db_username
 master_password         = var.db_password
 skip_final_snapshot     = true
 db_subnet_group_name    = aws_db_subnet_group.main.id
 vpc_security_group_ids  = [aws_security_group.db_sg.id]
 lifecycle {
   ignore_changes = [tags]
 }
 tags = {
   Name = "aurora-cluster-demo"
 }
}
resource "aws_db_subnet_group" "main" {
 name       = "main-subnet-group"
 subnet_ids = [aws_subnet.private.id]
 tags = {
   Name = "main-subnet-group"
 }
}
resource "aws_rds_cluster_instance" "aurora_instances" {
 count              = 1
 identifier         = "aurora-instance-${count.index}"
 cluster_identifier = aws_rds_cluster.aurora.id
 instance_class     = var.db_instance_class
 tags = {
   Name = "aurora-instance"
 }
}

resource "null_resource" "db_setup" {
 depends_on = [aws_rds_cluster.aurora]
 provisioner "local-exec" {
   command = <<-EOT
     curl -o mysqlsampledatabase.sql
https://raw.githubusercontent.com/hhorak/mysql-sample-db/master/mysqlsampledatabase.sql
     mysql -h ${aws_rds_cluster.aurora.endpoint} -u ${var.db_username} -p${var.db_password} ${var.db_name} < mysqlsampledatabase.sql
   EOT
 }
}
