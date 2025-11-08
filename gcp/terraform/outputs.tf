output "vpc_network_self_link" {
  value = module.vpc.network_self_link
}

output "vpc_subnet_self_links" {
  value = module.vpc.subnet_self_links
}

output "nat_name" {
  value = module.nat.nat_name
}

output "router_self_link" {
  value = module.nat.router_self_link
}

output "cloud_armor_security_policy_self_link" {
  value = module.cloud_armor.security_policy_self_link
}

# Conditional outputs for optional modules
output "storage_bucket_self_link" {
  value = length(module.storage) > 0 ? module.storage[0].bucket_self_link : ""
}

output "load_balancer_forwarding_rule" {
  value = length(module.load_balancer) > 0 ? module.load_balancer[0].forwarding_rule_self_link : ""
}

output "load_balancer_ip" {
  value = length(module.load_balancer) > 0 ? module.load_balancer[0].forwarding_rule_ip : ""
}

output "load_balancer_managed_cert" {
  value = length(module.load_balancer) > 0 ? module.load_balancer[0].managed_certificate_self_link : ""
}

