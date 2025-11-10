resource "google_compute_network" "this" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnets" {
  for_each                 = { for s in var.subnets : s.name => s }
  name                     = each.key
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.this.self_link
  private_ip_google_access = each.value.private
  project                  = var.project_id
}

locals {
  subnet_self_links = [for s in google_compute_subnetwork.subnets : s.self_link]
}
