
output "bastion_public_ip" {
  description = "O IP público do Bastion Host."
  value       = aws_instance.bastion.public_ip
}

output "bastion_id" {
  description = "O ID da instância do Bastion Host."
  value       = aws_instance.bastion.id
}

