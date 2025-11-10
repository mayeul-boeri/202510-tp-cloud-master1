variable "project_id" {
  type        = string
  description = "GCP project ID for resources"
}

variable "region" {
  type        = string
  description = "Primary region for resources (unused by network but accepted)"
}

variable "network_name" {
  type        = string
  description = "Name of the VPC network to create"
}

variable "subnets" {
  description = "List of subnets to create. Each item: name, ip_cidr_range, region, private (bool)"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
    private       = bool
  }))
}

variable "enable_nat" {
  description = "Whether to create Cloud Router / Cloud NAT resources (used by higher-level module)."
  type        = bool
  default     = false
}
