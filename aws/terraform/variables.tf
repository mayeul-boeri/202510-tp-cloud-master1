variable "aws_region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nom du projet utilisé pour tag"
  type        = string
  default     = "tpcloudv2"
}

variable "vpc_cidr" {
  description = "CIDR pour le VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use for subnets"
  type        = number
  default     = 2
}

variable "db_username" {
  description = "Nom d'utilisateur pour la DB MySQL"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Mot de passe pour la DB MySQL (sensible)"
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.db_password == null || (length(var.db_password) >= 8 && length(var.db_password) <= 41 && can(regex("^[^/@\\\\]*$", var.db_password)))
    error_message = "db_password must be between 8 and 41 characters and must not contain '/' or '@'."
  }
}

variable "db_instance_class" {
  description = "Classe d'instance RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Taille disque (Go) pour RDS"
  type        = number
  default     = 20
}

variable "instance_ami" {
  description = "AMI ID to use for application instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type for application instances"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}
