resource "tls_private_key" "pvk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "kf" {
  content  = tls_private_key.pvk.private_key_pem
  filename = "kf.pem"
}

resource "aws_key_pair" "kf" {
  key_name   = var.key_name
  public_key = tls_private_key.pvk.public_key_openssh
}
