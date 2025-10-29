variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
}

variable "vpc_id" {
  description = "O ID da VPC onde o ALB será implantado."
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas onde o ALB será implantado."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ID do Security Group para o ALB."
  type        = string
}

variable "app_port" {
  description = "A porta em que a aplicação web está rodando nas instâncias de destino."
  type        = number
  default     = 5000
}

variable "common_tags" {
  description = "Mapa de tags comuns a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

# Variável apenas para o nome do bucket
variable "log_bucket_name" {
  description = "Nome do bucket para logs do ALB"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID (passado do root module) para logs do ALB"
  type        = string
}
