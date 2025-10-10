
variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
}

variable "vpc_id" {
  description = "O ID da VPC onde os Security Groups serão criados."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC."
  type        = string
}

variable "app_port" {
  description = "A porta em que a aplicação web está rodando."
  type        = number
  default     = 5000
}

variable "common_tags" {
  description = "Mapa de tags comuns a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "private_rds_subnet_cidrs" {
  description = "Lista de CIDR blocks para as subnets privadas do RDS."
  type        = list(string)
}

variable "private_web_subnet_cidrs" {
  description = "Lista de CIDR blocks para as subnets privadas dos webservers."
  type        = list(string)
}
