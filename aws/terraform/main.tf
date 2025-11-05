terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  az_count     = var.az_count
}

module "security" {
  source             = "./modules/security"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "db" {
  source               = "./modules/db"
  project_name         = var.project_name
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_username          = var.db_username
  db_password          = var.db_password
  db_sg_id             = module.security.db_sg_id
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  public_subnet_ids = module.vpc.public_subnet_ids
  web_sg_id         = module.security.web_sg_id
  vpc_id            = module.vpc.vpc_id
}

module "waf" {
  source       = "./modules/waf"
  project_name = var.project_name
  alb_arn      = module.alb.alb_arn
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "asg" {
  source                = "./modules/asg"
  project_name          = var.project_name
  instance_ami          = var.instance_ami
  instance_type         = var.instance_type
  web_sg_id             = module.security.web_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_arns     = [module.alb.target_group_arn]
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
  instance_profile_name = module.iam.instance_profile_name
}

module "monitoring" {
  source         = "./modules/monitoring"
  project_name   = var.project_name
  db_instance_id = module.db.db_instance_id
  asg_name       = module.asg.asg_name
}

module "backup" {
  source        = "./modules/backup"
  project_name  = var.project_name
  db_arn        = module.db.db_arn
  s3_bucket_arn = try(module.s3.bucket_arn, "")
}

