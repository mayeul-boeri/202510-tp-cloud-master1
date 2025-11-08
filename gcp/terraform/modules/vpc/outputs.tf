output "network_self_link" {
  value = google_compute_network.this.self_link
}

output "subnet_self_links" {
  value = local.subnet_self_links
}
