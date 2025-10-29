
variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
}

variable "private_rds_subnet_ids" {
  description = "Lista de IDs das subnets privadas para o RDS."
  type        = list(string)
}

variable "rds_sg_id" {
  description = "ID do Security Group para o RDS."
  type        = string
}

variable "allocated_storage" {
  description = "Tamanho do armazenamento alocado para o RDS em GB."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "Versão do motor do banco de dados."
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "Classe da instância do RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Nome de usuário para o banco de dados."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha para o banco de dados. **ATENÇÃO: Em produção, usar Secrets Manager.**"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados."
  type        = string
  default     = "appdb"
}

variable "multi_az" {
  description = "Habilitar Multi-AZ para alta disponibilidade do RDS."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Mapa de tags comuns a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

