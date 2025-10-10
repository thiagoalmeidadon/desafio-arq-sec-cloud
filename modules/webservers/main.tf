
resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = var.aws_ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.private_web_subnet_ids, count.index)
  vpc_security_group_ids = [var.web_sg_id]
  key_name               = var.key_name

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_host  = var.rds_endpoint,
    db_user  = var.db_username,
    db_pass  = var.db_password,
    db_name  = var.db_name,
    app_port = var.app_port
  }))

  tags = merge(var.common_tags, { Name = "${var.project_name}-webserver-${count.index + 1}" })
}

