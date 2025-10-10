
output "webserver_ids" {
  description = "Os IDs das instâncias EC2 dos webservers."
  value       = aws_instance.web[*].id
}

output "webserver_private_ips" {
  description = "Os IPs privados das instâncias EC2 dos webservers."
  value       = aws_instance.web[*].private_ip
}

