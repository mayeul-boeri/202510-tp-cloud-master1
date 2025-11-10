output "security_policy_name" {
  value = google_compute_security_policy.this.name
}

output "security_policy_self_link" {
  value = google_compute_security_policy.this.self_link
}
