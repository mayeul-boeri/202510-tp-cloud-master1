/*
  Clean instance_group module
  - single, consistent copy of resources (no duplicated blocks)
  - metadata_startup_script is used to inject startup script into template
*/

resource "google_compute_instance_template" "this" {
  name_prefix = "${var.name_prefix}-template-"
  project     = var.project_id

  disk {
    auto_delete = true
    boot        = true
    source_image = var.source_image
    disk_size_gb = 10
  }

  network_interface {
    network    = var.network_self_link
    subnetwork = var.subnetwork_self_link
    access_config {}
  }

  machine_type = var.machine_type

  # Inject the startup script (empty string means no metadata key will be set by the provider)
  metadata_startup_script = var.startup_script

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "this" {
  count               = var.region != "" ? 1 : 0
  name                = "${var.name_prefix}-mig"
  project             = var.project_id
  region              = var.region
  base_instance_name  = var.name_prefix
  version {
    instance_template = google_compute_instance_template.this.self_link
  }
  target_size = var.instance_count

  dynamic "auto_healing_policies" {
    for_each = var.enable_health_check ? [1] : []
    content {
      health_check = google_compute_health_check.this[0].self_link
      initial_delay_sec = var.auto_healing_initial_delay
    }
  }
  
  # Named ports so backend services can reference a port_name (http -> 80)
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_instance_group" "this" {
  count = var.region == "" ? 1 : 0
  name  = "${var.name_prefix}-ig"
  project = var.project_id
  zone = var.zone
  # Named port for zonal instance groups
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_region_autoscaler" "this" {
  count = var.enable_autoscaling && var.region != "" ? 1 : 0
  name  = "${var.name_prefix}-autoscaler"
  project = var.project_id
  region  = var.region

  target = google_compute_region_instance_group_manager.this[0].self_link

  autoscaling_policy {
    min_replicas = var.autoscaling_min_replicas
    max_replicas = var.autoscaling_max_replicas

    cpu_utilization {
      target = var.autoscaling_cpu_target
    }
  }
}

# Optional health check for MIG autohealing
resource "google_compute_health_check" "this" {
  count = var.enable_health_check && var.region != "" ? 1 : 0
  name = "${var.name_prefix}-mig-hc"
  project = var.project_id

  http_health_check {
    port = 80
    request_path = "/"
  }
}

# Set named ports on the managed instance group so backend services using port_name can map to TCP ports.
# We use a local-exec provisioner because the provider does not currently expose a first-class named_ports
# setter for managed instance groups. This will run where 'terraform apply' is executed and requires gcloud
# to be installed and authenticated with sufficient rights.
/* named ports are now handled by the instance_group resources directly */
