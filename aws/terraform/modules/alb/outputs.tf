output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.app_alb.arn
}
