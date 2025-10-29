
output "alb_dns_name" {
  description = "O nome DNS do Application Load Balancer."
  value       = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "O ARN do Application Load Balancer."
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "O ARN do Target Group do ALB."
  value       = aws_lb_target_group.alb_tg.arn
}
