
variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para as subnets públicas."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.5.0/24"]
}

variable "private_web_subnet_cidrs" {
  description = "Lista de CIDR blocks para as subnets privadas dos webservers."
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_rds_subnet_cidrs" {
  description = "Lista de CIDR blocks para as subnets privadas do RDS."
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "Lista de Availability Zones a serem usadas."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "common_tags" {
  description = "Mapa de tags comuns a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

