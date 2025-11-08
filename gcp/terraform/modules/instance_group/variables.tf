variable "project_id" {
  type        = string
  description = "GCP project id where resources will be created"
}

variable "region" {
  type        = string
  default     = ""
  description = "Region for regional resources. Leave empty when using zonal (zone variable)."
}

variable "zone" {
  type        = string
  default     = ""
  description = "Zone for zonal instance groups. Leave empty when using regional (region variable)."
}

variable "name_prefix" {
  type        = string
  default     = "tpcloud-lb"
  description = "Prefix used for naming instance group resources"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "source_image" {
  type    = string
  default = "projects/debian-cloud/global/images/family/debian-11"
}

variable "network_self_link" {
  type    = string
  default = ""
  description = "Self link to the VPC network to attach interfaces to"
}

variable "subnetwork_self_link" {
  type    = string
  default = ""
  description = "Self link to the subnetwork to attach interfaces to"
}

variable "startup_script" {
  type        = string
  default     = ""
  description = "Startup script (bash) to be injected into the instance template. Leave empty to omit."
}

# Autoscaling
variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "autoscaling_min_replicas" {
  type    = number
  default = 1
}

variable "autoscaling_max_replicas" {
  type    = number
  default = 3
}

variable "autoscaling_cpu_target" {
  type        = number
  default     = 0.6
  description = "Target CPU utilization (0-1) for the autoscaler"
}

# Health check & auto-healing
variable "enable_health_check" {
  type    = bool
  default = false
}

variable "auto_healing_initial_delay" {
  type        = number
  default     = 300
  description = "Initial delay in seconds before autohealing considers an instance unhealthy"
}

# Placeholder for custom metric autoscaling (documented, not implemented automatically)
variable "enable_custom_metric_autoscaling" {
  type    = bool
  default = false
}

variable "custom_metric_type" {
  type        = string
  default     = ""
  description = "If you want to drive autoscaling from a Stackdriver custom metric, set its type here (e.g. custom.googleapis.com/my_metric)."
}

variable "custom_metric_target" {
  type        = number
  default     = 0.0
  description = "Target utilization for the custom metric (meaning depends on the metric)."
}
