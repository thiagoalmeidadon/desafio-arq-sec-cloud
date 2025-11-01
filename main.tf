###############################
#    IAM Role para EC2 
###############################
resource "aws_iam_role" "ec2_role" {
  name = "${local.project_name}-${local.env}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_secretsmanager" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${local.project_name}-${local.env}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

###############################
#        Bastion  
###############################
resource "aws_instance" "bastion" {
  ami                         = local.ami_id
  instance_type               = local.instance_type_bastion
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = local.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              EOF

  tags = {
    Name        = "${local.project_name}-${local.env}-bastion"
    Environment = local.env
  }
}

###############################
#      Web Instances
###############################
resource "aws_instance" "web" {
  count                      = 2
  ami                        = local.ami_id
  instance_type              = local.instance_type_web
  subnet_id                  = aws_subnet.private.id
  vpc_security_group_ids     = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  key_name                   = local.key_name
  iam_instance_profile       = aws_iam_instance_profile.ec2_instance_profile.name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php php-mbstring php-xml php-pgsql wget unzip
              systemctl enable --now httpd
              EOF

  tags = {
    Name        = "${local.project_name}-${local.env}-web-${count.index}"
    Environment = local.env
  }
}

###############################
#           RDS 
###############################
resource "random_password" "db_pass" {
  length  = 20
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${local.project_name}-${local.env}-db-credentials"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.project_name}-${local.env}-db-subnet-group"
  subnet_ids = [aws_subnet.private.id]
}

resource "aws_db_instance" "postgres" {
  identifier             = "${local.project_name}-${local.env}-rds"
  engine                 = local.db_engine
  engine_version         = local.db_engine_version
  instance_class         = local.db_instance_class
  db_name                = local.db_name
  username               = local.db_username
  password               = random_password.db_pass.result
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  allocated_storage      = 20
  storage_encrypted      = true
  skip_final_snapshot    = true

  tags = {
    Name        = "${local.project_name}-${local.env}-rds"
    Environment = local.env
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = local.db_username
    password = random_password.db_pass.result
    host     = aws_db_instance.postgres.address
    port     = 5432
    engine   = local.db_engine
    dbname   = local.db_name
  })
}

###############################
#          Outputs
###############################

output "bastion_public_ip" {
  description = "Endereço público do Bastion"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Endereço privado do Bastion"
  value       = aws_instance.bastion.private_ip
}

output "web_private_ips" {
  description = "Lista de IPs privados da EC2 Web"
  value       = [for instance in aws_instance.web : instance.private_ip]
}

output "rds_endpoint" {
  description = "Endpoint do PostgreSQL"
  value       = aws_db_instance.postgres.address
}

# Nome do secret no Secrets Manager
output "db_secret_name" {
  description = "Secret com as credenciais do banco"
  value       = aws_secretsmanager_secret.db_secret.name
}
