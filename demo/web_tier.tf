resource "aws_instance" "demo_web" {
 ami           = var.ec2_ami 
 instance_type = var.instance_type
 subnet_id     = aws_subnet.demo_plc_subnet.id
 security_groups = [aws_security_group.demo_web_sg.id]
 user_data = <<-EOF
             #!/bin/bash
             yum update -y
             yum install -y httpd mariadb105
             systemctl start httpd
             systemctl enable httpd
             echo "Hello, World from $(hostname -f)" > /var/www/html/index.html
             curl -o /tmp/mysqlsampledatabase.sql https://raw.githubusercontent.com/hhorak/mysql-sample-db/master/mysqlsampledatabase.sql
             #Wait for the RDS instance to be available
             while ! nc -z ${aws_rds_cluster.demo_db_cluster.endpoint} 3306; do
               echo "Waiting for RDS instance to be available..."
               sleep 10
             done
             # Execute the schema file
             mysql -h ${aws_rds_cluster.demo_db_cluster.endpoint} -u ${var.db_username} -p${var.db_password} ${var.db_name} < /tmp/mysqlsampledatabase.sql
             rm -f /tmp/mysqlsampledatabase.sql
             EOF
 tags = {
   Name = "demo-web-instance"
 }
 depends_on = [ aws_vpc.demo_vpc, aws_subnet.demo_plc_subnet, aws_security_group.demo_web_sg, aws_rds_cluster.demo_db_cluster ]
}