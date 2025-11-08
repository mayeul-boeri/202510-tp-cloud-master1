module "vpc" {
  source       = "./modules/vpc"
  project_id   = var.project_id
  region       = var.region
  network_name = var.network_name
  subnets      = var.subnets
  enable_nat   = true
}

module "nat" {
  source             = "./modules/nat"
  project_id         = var.project_id
  region             = var.region
  router_name        = "${var.network_name}-router"
  nat_name           = "${var.network_name}-nat"
  network_self_link  = module.vpc.network_self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork_self_links = module.vpc.subnet_self_links
}

module "cloud_armor" {
  source               = "./modules/cloud_armor"
  security_policy_name = "${var.network_name}-security-policy"
  description          = "Cloud Armor policy for ${var.network_name}"
  # optionally provide IP ranges to block
  block_ip_ranges      = []
}

# IAM: create service accounts used by instances and deployer
module "iam" {
  source      = "./modules/iam"
  project_id  = var.project_id
  name_prefix = var.network_name
}

# Optional KMS for CMEK
module "kms" {
  count      = var.enable_kms ? 1 : 0
  source     = "./modules/kms"
  project_id = var.project_id
  location   = var.kms_location
  name_prefix = var.network_name
}

# Optional monitoring scaffold
module "monitoring" {
  count = var.enable_monitoring ? 1 : 0
  source = "./modules/monitoring"
  project_id = var.project_id
  create_notification_channel = var.monitoring_notification_email != "" ? true : false
  notification_email = var.monitoring_notification_email
  # decide creation of uptime check from known variables (avoid using module outputs in condition)
  enable_uptime_check = var.enable_monitoring && var.enable_load_balancer
  # pass the LB forwarding IP (may be unknown at plan time) — the module will create the uptime check when enabled
  uptime_host = length(module.load_balancer) > 0 ? module.load_balancer[0].forwarding_rule_ip : ""
}

# Optional Storage bucket (disabled by default). Enable by setting var.enable_storage = true
module "storage" {
  count      = var.enable_storage ? 1 : 0
  source     = "./modules/storage"
  project_id = var.project_id
  name       = var.storage_bucket_name
  location   = "US"
  versioning = true
  force_destroy = false
  lifecycle_days = 365
  kms_key_name = var.enable_kms && length(module.kms) > 0 ? module.kms[0].crypto_key_id : ""
}

# Optional HTTPS Load Balancer scaffold (disabled by default). Enable by setting var.enable_load_balancer = true
module "load_balancer" {
  count = var.enable_load_balancer ? 1 : 0
  source = "./modules/load_balancer"
  project_id = var.project_id
  enable = var.enable_load_balancer
  name_prefix = var.load_balancer_name_prefix
  bucket_name = var.load_balancer_bucket_name
  ssl_certificate_self_links = var.load_balancer_ssl_certificates
  # Use the managed instance group's instance group (not the manager) as the backend group
  backend_instance_group_self_link = var.enable_instance_group && length(module.instance_group) > 0 ? module.instance_group[0].instance_group_self_link : ""
  enable_backend_service = var.enable_instance_group
  attach_cloud_armor_policy = false
  cloud_armor_policy_self_link = module.cloud_armor.security_policy_self_link
}

# Optional instance group scaffold for LB backends
module "instance_group" {
  count = var.enable_instance_group ? 1 : 0
  source = "./modules/instance_group"
  project_id = var.project_id
  region = var.region
  # If a region is provided we create a regional MIG (leave zone unset/null).
  zone   = var.region != "" ? null : var.zone
  name_prefix = var.instance_group_name_prefix
  instance_count = var.instance_group_count
  machine_type = var.instance_group_machine_type
  source_image = var.instance_group_image
  network_self_link = module.vpc.network_self_link
  # Prefer null instead of empty-string when the subnetwork is absent (keeps types consistent).
  subnetwork_self_link = length(module.vpc.subnet_self_links) > 0 ? module.vpc.subnet_self_links[0] : null
  # autoscaling and health check inputs
  enable_autoscaling = var.instance_group_enable_autoscaling
  autoscaling_min_replicas = var.instance_group_autoscaling_min_replicas
  autoscaling_max_replicas = var.instance_group_autoscaling_max_replicas
  autoscaling_cpu_target = var.instance_group_autoscaling_cpu_target
  enable_health_check = var.instance_group_enable_health_check
  auto_healing_initial_delay = var.instance_group_auto_healing_initial_delay
  # allow null when no startup script is provided
  startup_script = var.instance_group_startup_script != "" ? var.instance_group_startup_script : null
}

# Optional Cloud SQL instance (disabled by default)
module "cloud_sql" {
  count = var.enable_cloud_sql ? 1 : 0
  source = "./modules/cloud_sql"
  project_id = var.project_id
  region = var.region
  instance_name = var.cloud_sql_instance_name
  database_name = var.cloud_sql_database_name
  network_self_link = module.vpc.network_self_link
  deletion_protection = false
  use_private_network = var.cloud_sql_use_private_network
  # Optional DB user + Secret Manager (opt-in)
  create_secret = var.create_secret
  db_user_create = var.db_user_create
  db_password = var.db_password
  instance_service_account_email = module.iam.instance_service_account_email
}

# When the user requests Cloud SQL private IP, create a reserved internal IP range
# and a service networking connection (VPC peering) to the service networking API.
resource "google_compute_global_address" "cloud_sql_private_range" {
  count = var.cloud_sql_use_private_network ? 1 : 0
  name = "tpcloud-cloudsql-private-range"
  purpose = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = module.vpc.network_self_link
  project = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count = var.cloud_sql_use_private_network ? 1 : 0
  network = module.vpc.network_self_link
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloud_sql_private_range[0].name]
}

# Ensure GCP HTTP(S) load balancer health checks can reach instances
resource "google_compute_firewall" "allow_lb_healthchecks_http" {
  count   = var.enable_load_balancer ? 1 : 0
  name    = "allow-lb-healthchecks-http"
  project = var.project_id
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22","35.191.0.0/16"]
  description   = "Allow GCP load balancer and health checks to reach instances on port 80"
}
