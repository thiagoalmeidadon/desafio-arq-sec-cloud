provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc_prd" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_prd.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc_prd.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id

  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_prd.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

}


resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "webserver-ssh-http" {
  name        = "webserver-ssh-http"
  description = "Libera trafego http e ssh"
  vpc_id      = aws_vpc.vpc_prd.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "tls_private_key" "pvk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "kf" {
  content  = tls_private_key.pvk.private_key_pem
  filename = "kf.pem"
}

resource "aws_key_pair" "kf" {
  key_name   = "kf"
  public_key = tls_private_key.pvk.public_key_openssh
}

resource "aws_instance" "webserver" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.kf.key_name
  tags                   = { name = "webserver" }
  vpc_security_group_ids = [aws_security_group.webserver-ssh-http.id]


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.pvk.private_key_pem
    host        = self.public_dns
  }

  provisioner "file" {
    source      = "wait.sh"
    destination = "/tmp/wait.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'connected!'",
      "sudo chmod +x /tmp/wait.sh",
      "sudo /tmp/wait.sh"
    ]
  }
}
