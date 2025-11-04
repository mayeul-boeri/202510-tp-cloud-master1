variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_region_dr" {
  type    = string
  default = "us-west-2"
}

variable "project" {
  type    = string
  default = "TP"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnets" {
  type = list(object({
    name = string
    cidr = string
    zone = string
    type = string
  }))
}

variable "nat_gateway_subnet_name" {
  description = "The name of the subnet to use for the NAT Gateway"
  type        = string
}

variable "azs" {
  type    = list(string)
  default = []
}

variable "ami_id" {
  type    = string
  default = "ami-0c2b8ca1dad447f8a"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_username" {
  type = string
}

variable "ec2_password" {
  type = string
}

variable "rds_secret_name" {
  description = "Nom du secret manager pour les credentials RDS"
  type        = string
}