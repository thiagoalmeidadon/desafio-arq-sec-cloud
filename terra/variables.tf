variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Região AWS"
}

variable "az" {
  type        = string
  default     = "us-east-1a"
  description = "Availability Zone para a subnet pública"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "CIDR da VPC"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.10.1.0/24"
  description = "CIDR da subnet pública"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Tipo da instância EC2"
}