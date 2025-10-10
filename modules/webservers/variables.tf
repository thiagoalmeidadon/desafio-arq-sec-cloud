variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
  default     = "Desafio-Arq-Sec-Cloud"
}

variable "aws_ami_id" {
  description = "ID da AMI para as instâncias EC2."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2 para os webservers."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nome do key pair SSH para acesso às instâncias."
  type        = string
}

variable "web_sg_id" {
  description = "ID do Security Group para os webservers."
  type        = string
}

variable "private_web_subnet_ids" {
  description = "Lista de IDs das subnets privadas onde os webservers serão lançados."
  type        = list(string)
}

variable "instance_count" {
  description = "Número de instâncias EC2 fixas a serem criadas."
  type        = number
  default     = 2
}

variable "rds_endpoint" {
  description = "Endpoint do banco de dados RDS."
  type        = string
}

variable "db_username" {
  description = "Nome de usuário do banco de dados RDS."
  type        = string
}

variable "db_password" {
  description = "Senha do banco de dados RDS. **ATENÇÃO: Em produção, usar Secrets Manager.**"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados."
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


