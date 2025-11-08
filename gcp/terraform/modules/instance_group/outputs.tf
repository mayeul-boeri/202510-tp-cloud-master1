output "instance_template_self_link" {
  value = google_compute_instance_template.this.self_link
}

output "mig_self_link" {
  value = length(google_compute_region_instance_group_manager.this) > 0 ? google_compute_region_instance_group_manager.this[0].self_link : ""
}

output "instance_group_self_link" {
  # For zonal groups we expose google_compute_instance_group.this[].self_link
  # For regional managed instance groups we expose the instance_group attribute from the manager resource.
  value = length(google_compute_instance_group.this) > 0 ? google_compute_instance_group.this[0].self_link : (length(google_compute_region_instance_group_manager.this) > 0 ? google_compute_region_instance_group_manager.this[0].instance_group : "")
}
