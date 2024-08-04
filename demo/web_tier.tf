resource "aws_instance" "demo_web" {
 ami           = var.ec2_ami 
 instance_type = var.instance_type
 subnet_id     = aws_subnet.demo_plc_subnet.id
 security_groups = [aws_security_group.demo_web_sg.id]
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
 depends_on = [ aws_vpc.demo_vpc, aws_subnet.demo_plc_subnet, aws_security_group.demo_web_sg ]
}