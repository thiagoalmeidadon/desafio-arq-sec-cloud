
output "alb_sg_id" {
  description = "O ID do Security Group para o ALB."
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "O ID do Security Group para o Bastion Host."
  value       = aws_security_group.bastion_sg.id
}

output "web_sg_id" {
  description = "O ID do Security Group para os Webservers."
  value       = aws_security_group.web_sg.id
}

output "rds_sg_id" {
  description = "O ID do Security Group para o RDS."
  value       = aws_security_group.rds_sg.id
}

