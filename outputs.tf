
output "alb_dns_name" {
  description = "O nome DNS do Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "O endpoint do banco de dados RDS."
  value       = module.rds.rds_endpoint
}

output "bastion_public_ip" {
  description = "O IP público do Bastion Host."
  value       = module.bastion.bastion_public_ip
}

output "ssh_key_pem" {
  description = "Conteúdo da chave privada SSH (kf.pem)."
  value       = local_file.kf.content
  sensitive   = true
}

output "webserver_instance_ids" {
  description = "Os IDs das instâncias EC2 dos webservers."
  value       = module.webservers.webserver_ids
}

