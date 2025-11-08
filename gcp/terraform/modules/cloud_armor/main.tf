resource "google_compute_security_policy" "this" {
  name        = var.security_policy_name
  description = var.description

  rule {
    action = "allow"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
  }

  dynamic "rule" {
    for_each = var.block_ip_ranges
    content {
      action   = "deny(403)"
      priority = 100
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = [rule.value]
        }
      }
    }
  }

  # Default rule required by Cloud Armor: priority 2147483647, match all.
  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        # match all sources
        src_ip_ranges = ["*"]
      }
    }
  }
}
