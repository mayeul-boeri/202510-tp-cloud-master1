resource "google_compute_router" "this" {
  name    = var.router_name
  network = var.network_self_link
  region  = var.region
  project = var.project_id
}

resource "google_compute_router_nat" "this" {
  name                               = var.nat_name
  router                             = google_compute_router.this.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? var.subnetwork_self_links : []
    content {
      name                         = subnetwork.value
      source_ip_ranges_to_nat      = ["ALL_IP_RANGES"]
    }
  }
}
