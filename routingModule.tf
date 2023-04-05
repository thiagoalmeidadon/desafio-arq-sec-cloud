resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc_prd.id


  route {
    cidr_block = var.cidr_blocks_any
    gateway_id = aws_internet_gateway.gw.id

  }
  tags = { name = "Route_Table_Desafio" }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}
