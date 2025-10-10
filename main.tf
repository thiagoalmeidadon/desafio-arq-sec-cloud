provider "aws" {
  region = var.aws_region
}

# Geração do Key Pair SSH
resource "tls_private_key" "pvk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "kf" {
  content  = tls_private_key.pvk.private_key_pem
  filename = "${path.module}/kf.pem"
}

resource "aws_key_pair" "kf" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.pvk.public_key_openssh
}

# Módulo VPC
module "vpc" {
  source = "./modules/vpc"

  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_web_subnet_cidrs = var.private_web_subnet_cidrs
  private_rds_subnet_cidrs = var.private_rds_subnet_cidrs
  availability_zones       = var.availability_zones
  common_tags              = var.common_tags
}

# Módulo Security Groups
module "security_groups" {
  source                   = "./modules/security_groups"
  vpc_cidr                 = var.vpc_cidr
  project_name             = var.project_name
  vpc_id                   = module.vpc.vpc_id
  app_port                 = var.app_port
  common_tags              = var.common_tags
  private_rds_subnet_cidrs = var.private_rds_subnet_cidrs
  private_web_subnet_cidrs = var.private_web_subnet_cidrs
}

# Módulo RDS
module "rds" {
  source = "./modules/rds"

  project_name           = var.project_name
  private_rds_subnet_ids = module.vpc.private_rds_subnet_ids
  rds_sg_id              = module.security_groups.rds_sg_id
  db_username            = var.db_username
  db_password            = var.db_password
  db_name                = var.db_name
  multi_az               = var.rds_multi_az
  common_tags            = var.common_tags
}

# S3 para Logs (ALB, CloudTrail, VPC Flow Logs)
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "${var.project_name}-logs-${random_id.suffix.hex}"
  force_destroy = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-logs"
  })
}


# Política do bucket — permitir logs de ALB, CloudTrail e VPC
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket = aws_s3_bucket.logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ALB Logs - Permissão para ELB Service Account
      {
        Sid       = "AllowALBLogs"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::127311923021:root" } # ELB Service Account para us-east-1
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.logs_bucket.arn}/alb-logs/*"
      },
      # CloudTrail - Permissão para verificar ACL do bucket
      {
        Sid       = "AllowCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.logs_bucket.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${var.aws_region}:${data.aws_caller_identity.current.account_id}:trail/${var.project_name}-trail"
          }
        }
      },
      # CloudTrail - Permissão para escrever logs
      {
        Sid       = "AllowCloudTrailLogs"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "AWS:SourceArn" = "arn:aws:cloudtrail:${var.aws_region}:${data.aws_caller_identity.current.account_id}:trail/${var.project_name}-trail"
          }
        }
      }
    ]
  })
}


# Módulo ALB
module "alb" {
  source = "./modules/alb"

  log_bucket_name   = aws_s3_bucket.logs_bucket.bucket
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  app_port          = var.app_port
  common_tags       = var.common_tags
  account_id        = data.aws_caller_identity.current.account_id
}

# Módulo Webservers
module "webservers" {
  source = "./modules/webservers"

  project_name           = var.project_name
  aws_ami_id             = var.aws_ami_id
  instance_type          = var.webserver_instance_type
  key_name               = aws_key_pair.kf.key_name
  web_sg_id              = module.security_groups.web_sg_id
  private_web_subnet_ids = module.vpc.private_web_subnet_ids
  instance_count         = var.webserver_instance_count
  rds_endpoint           = module.rds.rds_endpoint
  db_username            = module.rds.rds_username
  db_password            = var.db_password
  db_name                = module.rds.rds_db_name
  app_port               = var.app_port
  common_tags            = var.common_tags
}

# Anexar EC2 ao Target Group do ALB
resource "aws_lb_target_group_attachment" "web_attach" {
  count            = var.webserver_instance_count
  target_group_arn = module.alb.target_group_arn
  target_id        = module.webservers.webserver_ids[count.index]
  port             = var.app_port
}

# Módulo Bastion Host
module "bastion" {
  source = "./modules/bastion"

  project_name     = var.project_name
  aws_ami_id       = var.aws_ami_id
  instance_type    = var.bastion_instance_type
  public_subnet_id = element(module.vpc.public_subnet_ids, 0)
  key_name         = aws_key_pair.kf.key_name
  bastion_sg_id    = module.security_groups.bastion_sg_id
  common_tags      = var.common_tags
}

# VPC Flow Logs → CloudWatch
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/${var.project_name}-flowlogs"
  retention_in_days = 90
  tags              = var.common_tags
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "${var.project_name}-vpc-flowlogs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "${var.project_name}-vpc-flowlogs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
  tags                 = var.common_tags
}

# CloudTrail (auditoria de API)
resource "aws_cloudtrail" "main_trail" {
  name                          = "${var.project_name}-trail"
  s3_bucket_name                = aws_s3_bucket.logs_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${aws_s3_bucket.logs_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/"]
    }
  }

  tags = merge(var.common_tags, { Name = "${var.project_name}-trail" })
}

