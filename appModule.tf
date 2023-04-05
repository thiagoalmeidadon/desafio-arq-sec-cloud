resource "aws_instance" "webserver" {
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = var.key_name
  tags                   = { name = "webserver" }
  vpc_security_group_ids = [aws_security_group.webserver-ssh-http.id]



  connection {
    type        = "ssh"
    user        = var.user
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
