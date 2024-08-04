output "web_instance_public_ip" {
 value = aws_instance.web.public_ip
}
output "db_endpoint" {
 value = aws_rds_cluster.aurora.endpoint
}
