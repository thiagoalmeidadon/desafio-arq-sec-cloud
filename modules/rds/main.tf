
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.private_rds_subnet_ids
  tags       = merge(var.common_tags, { Name = "${var.project_name}-rds-subnet-group" })
}

resource "aws_db_instance" "rds_mysql" {
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password # Em produção, usar Secrets Manager
  db_name                = var.db_name
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  multi_az               = var.multi_az
  publicly_accessible    = false
  tags                   = merge(var.common_tags, { Name = "${var.project_name}-rds-mysql" })
}

