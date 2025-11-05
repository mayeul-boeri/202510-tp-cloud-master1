variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB to associate the WAF with"
  type        = string
}
