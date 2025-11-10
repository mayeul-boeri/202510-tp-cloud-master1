output "forwarding_rule_self_link" {
  value = length(google_compute_global_forwarding_rule.this) > 0 ? google_compute_global_forwarding_rule.this[0].self_link : ""
}

output "forwarding_rule_ip" {
  value = length(google_compute_global_forwarding_rule.this) > 0 ? google_compute_global_forwarding_rule.this[0].ip_address : ""
}

output "managed_certificate_self_link" {
  value = length(google_compute_managed_ssl_certificate.this) > 0 ? google_compute_managed_ssl_certificate.this[0].self_link : ""
}

output "managed_certificate_domains" {
  value = length(google_compute_managed_ssl_certificate.this) > 0 ? google_compute_managed_ssl_certificate.this[0].managed[0].domains : []
}

output "url_map_self_link" {
  value = length(google_compute_url_map.with_backend) > 0 ? google_compute_url_map.with_backend[0].self_link : (length(google_compute_url_map.redirect) > 0 ? google_compute_url_map.redirect[0].self_link : "")
}

output "https_proxy_self_link" {
  value = length(google_compute_target_https_proxy.this) > 0 ? google_compute_target_https_proxy.this[0].self_link : ""
}

output "backend_service_self_link" {
  value = length(google_compute_backend_service.this) > 0 ? google_compute_backend_service.this[0].self_link : ""
}
