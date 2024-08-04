output "web_instance_public_ip" {
 value = aws_instance.demo_web.public_ip
}

output "db_endpoint" {
 value = aws_rds_cluster.demo_db_cluster.endpoint
}
