variable "my_ip" {
  type        = string
  description = "Seu endereço IP para liberar o acesso SSH"
}

provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "desafio_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "desafio-vpc"
  }
}

# Subnet
resource "aws_subnet" "desafio_subnet" {
  vpc_id     = aws_vpc.desafio_vpc.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "desafio-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "desafio_igw" {
  vpc_id = aws_vpc.desafio_vpc.id

  tags = {
    Name = "desafio-igw"
  }
}

# Route Table
resource "aws_route_table" "desafio_rt" {
  vpc_id = aws_vpc.desafio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.desafio_igw.id
  }

  tags = {
    Name = "desafio-rt"
  }
}

# Associação
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.desafio_subnet.id
  route_table_id = aws_route_table.desafio_rt.id
}


# Security Group
resource "aws_security_group" "desafio_sg" {
  name        = "desafio-web-sg"
  description = "Controla o acesso a instancia EC2"
  vpc_id      = aws_vpc.desafio_vpc.id

  # Regra de entrada para HTTP (acesso ao site)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de entrada para SSH (acesso para nós)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  # Regra de saída (permite que a máquina acesse a internet)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "desafio-sg"
  }
}
# Instância EC2
resource "aws_instance" "desafio_server" {
  # Imagem do sistema operacional (Ubuntu 22.04 para a região us-east-1)
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t3.micro" 
# Tamanho da máquina (dentro do nível gratuito da AWS)

  # Conectando a máquina na nossa rede
  subnet_id              = aws_subnet.desafio_subnet.id
  vpc_security_group_ids = [aws_security_group.desafio_sg.id]

  # Associando a chave SSH que criei no painel da AWS
  key_name = "desafio-uol-key"

  tags = {
    Name = "desafio-web-server"
  }
}
