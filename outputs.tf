output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}
output "rds_security_group_name" {
  value = aws_security_group.rds_sg.name
}
output "rds_host_name" {
  value = module.db.db_instance_endpoint
}