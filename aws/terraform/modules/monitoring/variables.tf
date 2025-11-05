variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "db_instance_id" {
  description = "RDS DB instance identifier"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}
