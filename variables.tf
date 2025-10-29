
variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "aws_ami_id" {
  description = "AMI Ubuntu para webserver e Host bastion"
  type        = string
  default     = "ami-0360c520857e3138f"
}

variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
  default     = "flask-app"
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

variable "app_port" {
  description = "A porta em que a aplicação web está rodando."
  type        = number
  default     = 5000
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

variable "rds_multi_az" {
  description = "Habilitar Multi-AZ para alta disponibilidade do RDS."
  type        = bool
  default     = true
}

variable "webserver_instance_type" {
  description = "Tipo da instância EC2 para os webservers."
  type        = string
  default     = "t3.micro"
}

variable "webserver_instance_count" {
  description = "Número de instâncias EC2 fixas a serem criadas para os webservers."
  type        = number
  default     = 2
}

variable "bastion_instance_type" {
  description = "Tipo da instância EC2 para o Bastion Host."
  type        = string
  default     = "t3.micro"
}

variable "common_tags" {
  description = "Mapa de tags comuns a serem aplicadas aos recursos."
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "FlaskApp"
    Owner       = "Lucas Santana"
  }
}

