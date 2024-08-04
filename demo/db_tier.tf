resource "aws_db_subnet_group" "demo_db_subnet_group" {
 name       = "demo-db-subnet-group"
 subnet_ids = [aws_subnet.demo_pvt_subnet_a.id, aws_subnet.demo_pvt_subnet_b.id]
 tags = {
   Name = "demo-db-subnet-group"
 }
}
resource "aws_rds_cluster" "demo_db_cluster" {
 cluster_identifier      = "demo-db-cluster"
 engine                  = var.db_engine
 master_username         = var.db_username
 master_password         = var.db_password
 skip_final_snapshot     = true
 db_subnet_group_name    = aws_db_subnet_group.demo_db_subnet_group.id
 vpc_security_group_ids  = [aws_security_group.demo_db_sg.id]
 lifecycle {
   ignore_changes = [tags]
 }
 tags = {
   Name = "demo-db-cluster"
 }
}
resource "aws_rds_cluster_instance" "demo_db_instance" {
 count              = 1
 identifier         = "demo-db-instance-${count.index}"
 cluster_identifier = aws_rds_cluster.demo_db_cluster.id
 instance_class     = var.db_instance_class
 engine             = var.db_engine
 tags = {
   Name = "demo-db-instance"
 }
}
resource "null_resource" "demo_db_setup" {
 depends_on = [aws_rds_cluster.demo_db_cluster, aws_rds_cluster_instance.demo_db_instance]
 provisioner "local-exec" {
   command = <<-EOT
     echo "Fetching sample database schema..."
     curl -o mysqlsampledatabase.sql https://raw.githubusercontent.com/hhorak/mysql-sample-db/master/mysqlsampledatabase.sql
     echo "Testing MySQL connection..."
     mysql -h ${aws_rds_cluster.demo_db_cluster.endpoint} -u ${var.db_username} -p${var.db_password} -e "SHOW DATABASES;"
     echo "Importing sample database schema..."
     mysql -h ${aws_rds_cluster.demo_db_cluster.endpoint} -u ${var.db_username} -p${var.db_password} ${var.db_name} < mysqlsampledatabase.sql
   EOT
 }
}