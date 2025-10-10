
output "rds_endpoint" {
  description = "O endpoint do banco de dados RDS."
  value       = aws_db_instance.rds_mysql.address
}

output "rds_db_name" {
  description = "O nome do banco de dados RDS."
  value       = aws_db_instance.rds_mysql.db_name
}

output "rds_username" {
  description = "O nome de usuário do banco de dados RDS."
  value       = aws_db_instance.rds_mysql.username
}

