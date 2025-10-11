output "instance_id" {
  value       = aws_instance.web.id
  description = "ID da instância EC2"
}

output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "IP público"
}

output "http_url" {
  value       = "http://${aws_instance.web.public_ip}"
  description = "URL HTTP do Hello World"
}