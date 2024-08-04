resource "aws_instance" "demo_web" {
 ami           = "ami-0ba9883b710b05ac6" # Amazon Linux 2 AMI
 instance_type = var.instance_type
 subnet_id     = aws_subnet.demo_plc_subnet.id
 security_groups = [aws_security_group.demo_web_sg.name]
 user_data = <<-EOF
             #!/bin/bash
             yum update -y
             yum install -y httpd
             systemctl start httpd
             systemctl enable httpd
             echo "Hello, World from $(hostname -f)" > /var/www/html/index.html
             EOF
 tags = {
   Name = "demo-web-instance"
 }
}
