
resource "aws_security_group" "alb_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP access to ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = var.private_web_subnet_cidrs
  }

  tags = merge(var.common_tags, { Name = "${var.project_name}-alb-sg" })
}

resource "aws_security_group" "bastion_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH access to Bastion Host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["187.89.17.225/32"] # Range de IP com acesso ao host bastion
  }

  egress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = var.private_web_subnet_cidrs
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_web_subnet_cidrs
  }



  tags = merge(var.common_tags, { Name = "${var.project_name}-bastion-sg" })
}

resource "aws_security_group" "web_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP (app port) from ALB and SSH from Bastion"

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.private_web_subnet_cidrs
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_rds_subnet_cidrs
  }


  tags = merge(var.common_tags, { Name = "${var.project_name}-web-sg" })
}

resource "aws_security_group" "rds_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-rds-sg"
  description = "Allow MySQL access from Webservers and SSH from Bastion"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  tags = merge(var.common_tags, { Name = "${var.project_name}-rds-sg" })
}

