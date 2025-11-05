output "web_sg_id" {
  value = module.security.web_sg_id
}

output "db_sg_id" {
  value = module.security.db_sg_id
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
output "db_password" {
  description = "DB admin password (sensitive)"
  value       = try(module.db.db_password, "")
  sensitive   = true
}
output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs des sous-réseaux publics"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs des sous-réseaux privés"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID de l'Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID du NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "route_table_public_id" {
  description = "Route table publique"
  value       = module.vpc.route_table_public_id
}

output "route_table_private_id" {
  description = "Route table privée"
  value       = module.vpc.route_table_private_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = try(module.alb.alb_dns_name, "")
}

output "s3_bucket_id" {
  description = "S3 bucket id"
  value       = try(module.s3.bucket_id, "")
}

output "s3_bucket_arn" {
  description = "S3 bucket arn"
  value       = try(module.s3.bucket_arn, "")
}
