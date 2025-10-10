
variable "project_name" {
  description = "Nome do projeto para tags e prefixos."
  type        = string
}

variable "aws_ami_id" {
  description = "ID da AMI para a instância do Bastion Host."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2 para o Bastion Host."
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  description = "ID da subnet pública onde o Bastion Host será lançado."
  type        = string
}

variable "key_name" {
  description = "Nome do key pair SSH para acesso ao Bastion Host."
  type        = string
}

variable "bastion_sg_id" {
  description = "ID do Security Group para o Bastion Host."
  type        = string
}

variable "common_tags" {
  description = "Mapa de tags comuns a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

