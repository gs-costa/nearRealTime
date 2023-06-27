output "rds_address" {
  value       = aws_db_instance.db_instance_poc_nrt.address
  sensitive   = false
  description = "Address of rds_instance"
}

output "rds_port" {
  value       = aws_db_instance.db_instance_poc_nrt.port
  sensitive   = false
  description = "port of rds_instance"
}

output "rds_user" {
  value       = aws_db_instance.db_instance_poc_nrt.username
  sensitive   = false
  description = "username of rds_instance"
}

output "rds_password" {
  value       = aws_db_instance.db_instance_poc_nrt.password
  sensitive   = true
  description = "Password of rds_instance"
}

output "rds_db" {
  value       = aws_db_instance.db_instance_poc_nrt.db_name
  sensitive   = false
  description = "db of rds_instance"
}