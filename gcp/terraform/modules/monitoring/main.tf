resource "google_monitoring_notification_channel" "email" {
  count = var.create_notification_channel && var.notification_email != "" ? 1 : 0
  project = var.project_id
  type    = "email"
  display_name = "${var.project_id}-email-notification"

  labels = {
    email_address = var.notification_email
  }
}

# Optional uptime check referencing the provided host (eg. load balancer IP or domain)
resource "google_monitoring_uptime_check_config" "lb_check" {
  count = var.enable_uptime_check ? 1 : 0
  project = var.project_id
  display_name = "LB uptime check for ${var.uptime_host}"

  http_check {
    path = "/"
    port = 80
    use_ssl = false
  }

  timeout = "10s"
  period  = "60s"

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = var.uptime_host
    }
  }
}

# Alerting policy: CPU utilization high across instances
resource "google_monitoring_alert_policy" "cpu_high" {
  project = var.project_id
  display_name = "CPU high (>=80%) - aggregated"
  combiner = "OR"

  notification_channels = length(google_monitoring_notification_channel.email) > 0 ? [google_monitoring_notification_channel.email[0].name] : []

  conditions {
    display_name = "VM instance CPU usage (mean) > 80%"
    condition_threshold {
      # require resource.type per API rules
      filter = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration = "300s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.8

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_MEAN"
        per_series_aligner   = "ALIGN_MEAN"
      }
    }
  }
}


