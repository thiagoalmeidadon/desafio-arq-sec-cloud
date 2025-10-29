
output "vpc_id" {
  description = "O ID da VPC criada."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Os IDs das subnets públicas."
  value       = aws_subnet.public[*].id
}

output "private_web_subnet_ids" {
  description = "Os IDs das subnets privadas para webservers."
  value       = aws_subnet.private_web[*].id
}

output "private_rds_subnet_ids" {
  description = "Os IDs das subnets privadas para RDS."
  value       = aws_subnet.private_rds[*].id
}

output "nat_gateway_ids" {
  description = "Os IDs dos NAT Gateways."
  value       = aws_nat_gateway.nat[*].id
}

