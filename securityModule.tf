resource "aws_security_group" "webserver-ssh-http" {
  name        = "webserver-ssh-http"
  description = "Libera trafego http e ssh"
  vpc_id      = aws_vpc.vpc_prd.id
  ingress {
    from_port   = var.service_ssh
    to_port     = var.service_ssh
    protocol    = var.protocol_tcp
    cidr_blocks = [var.cidr_blocks_any]
  }
  ingress {
    from_port   = var.service_http
    to_port     = var.service_http
    protocol    = var.protocol_tcp
    cidr_blocks = [var.cidr_blocks_any]
  }
  egress {
    from_port   = var.service_any
    to_port     = var.service_any
    protocol    = var.protocol_any
    cidr_blocks = [var.cidr_blocks_any]
  }
  tags = { name = "webserver-ssh-http" }
}
