locals {
  enabled = var.enable
}

# This scaffold creates a minimal global HTTPS load balancer stack when enabled.
# All resources use count = var.enable ? 1 : 0 so the module is inert by default.

resource "google_compute_backend_bucket" "this" {
  count      = local.enabled && var.bucket_name != "" ? 1 : 0
  name       = "${var.name_prefix}-backend-bucket"
  bucket_name = var.bucket_name
  project    = var.project_id
}

resource "google_compute_backend_service" "this" {
  count = local.enabled && var.enable_backend_service ? 1 : 0
  name  = "${var.name_prefix}-backend-svc"
  project = var.project_id

  backend {
    group = var.backend_instance_group_self_link
  }

  # A backend service requires at least one health check.
  health_checks = length(google_compute_health_check.this) > 0 ? [google_compute_health_check.this[0].self_link] : []

  protocol = "HTTP"
  security_policy = var.attach_cloud_armor_policy && var.cloud_armor_policy_self_link != "" ? var.cloud_armor_policy_self_link : null
}

resource "google_compute_health_check" "this" {
  count = local.enabled && var.enable_backend_service ? 1 : 0
  name = "${var.name_prefix}-hc"
  project = var.project_id

  http_health_check {
    request_path = "/"
    port = 80
  }
}

resource "google_compute_url_map" "with_backend" {
  count = local.enabled && length(google_compute_backend_service.this) > 0 ? 1 : 0
  name  = "${var.name_prefix}-url-map"
  default_service = google_compute_backend_service.this[0].self_link
}

resource "google_compute_url_map" "redirect" {
  count = local.enabled && length(google_compute_backend_service.this) == 0 ? 1 : 0
  name  = "${var.name_prefix}-url-map"
  default_url_redirect {
    strip_query = false
  }
}

resource "google_compute_target_https_proxy" "this" {
  # Create an HTTPS proxy when either explicit certificate self-links are provided
  # or when the module is configured to request a managed certificate for domains.
  count = local.enabled && (length(var.ssl_certificate_self_links) > 0 || length(var.managed_certificate_domains) > 0) ? 1 : 0
  name  = "${var.name_prefix}-https-proxy"
  url_map = length(google_compute_url_map.with_backend) > 0 ? google_compute_url_map.with_backend[0].self_link : google_compute_url_map.redirect[0].self_link
  ssl_certificates = length(var.ssl_certificate_self_links) > 0 ? var.ssl_certificate_self_links : (length(google_compute_managed_ssl_certificate.this) > 0 ? [google_compute_managed_ssl_certificate.this[0].self_link] : [])
}

resource "google_compute_global_forwarding_rule" "this" {
  count       = local.enabled ? 1 : 0
  name        = "${var.name_prefix}-fw-rule"
  target      = length(google_compute_target_https_proxy.this) > 0 ? google_compute_target_https_proxy.this[0].self_link : google_compute_target_http_proxy.this[0].self_link
  port_range  = length(google_compute_target_https_proxy.this) > 0 ? "443" : "80"
  project     = var.project_id
}

resource "google_compute_target_http_proxy" "this" {
  # Create an HTTP proxy only when no certificates (explicit or managed) are configured.
  count = local.enabled && (length(var.ssl_certificate_self_links) == 0 && length(var.managed_certificate_domains) == 0) ? 1 : 0
  name  = "${var.name_prefix}-http-proxy"
  url_map = length(google_compute_url_map.with_backend) > 0 ? google_compute_url_map.with_backend[0].self_link : google_compute_url_map.redirect[0].self_link
}

# Optional Google-managed SSL certificate (requires DNS validation for domains)
resource "google_compute_managed_ssl_certificate" "this" {
  count = local.enabled && length(var.managed_certificate_domains) > 0 ? 1 : 0
  name  = "${var.name_prefix}-managed-cert"
  project = var.project_id

  managed {
    domains = var.managed_certificate_domains
  }
}

# Optionally create Cloud DNS A records for managed domains so that Google-managed certs can validate
resource "google_dns_record_set" "managed_cert_a" {
  for_each = var.manage_dns_records && length(google_compute_global_forwarding_rule.this) > 0 ? toset(var.managed_certificate_domains) : toset([])
  name     = "${each.key}."
  type     = "A"
  ttl      = 300
  project  = var.project_id
  managed_zone = var.managed_zone
  rrdatas  = [google_compute_global_forwarding_rule.this[0].ip_address]
}
