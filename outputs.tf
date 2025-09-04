output "instance_public_ip" {
  description = "O endereço IP público da instância EC2"
  value       = aws_instance.desafio_server.public_ip
}
