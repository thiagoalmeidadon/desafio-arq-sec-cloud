provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc_prd" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_prd.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_prd.id
  cidr_block = "10.0.2.0/28"
}

resource "tls_private_key" "pvk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "tk" {
  content  = tls_private_key.pvk.private_key_pem
  filename = "tk.pem"
}

resource "aws_key_pair" "kf" {
  key_name   = "kf"
  public_key = tls_private_key.pvk.public_key_openssh
}

resource "aws_instance" "webserver" {
  ami           = "ami-0fec2c2e2017f4e7b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.kf.key_name
  tenancy       = "host"

  /* provisioner "remote-exec" {
    //host = aws_instance.webserver.public_ip
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user",
      "sudo docker pull strm/helloworld-http"
    ]
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = tls_private_key.pvk.private_key_pem
    host        = aws_instance.webserver.public_ip
  }
  */ 
}