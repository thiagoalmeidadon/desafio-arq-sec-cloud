resource "aws_vpc" "vpc_prd" {
  cidr_block           = var.cidr_block_vpc_prd
  enable_dns_hostnames = true
  tags                 = { name = "VPC_Prod_Desafio" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_prd.id
  tags   = { name = "GateWay_Desafio" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_prd.id
  cidr_block              = var.cidr_block_public_subnet
  map_public_ip_on_launch = "true"
  tags                    = { name = "Subnet_Pública_Desafio" }
}
