
resource "aws_instance" "bastion" {
  ami                    = var.aws_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.bastion_sg_id]
  tags                   = merge(var.common_tags, { Name = "${var.project_name}-bastion" })
}

