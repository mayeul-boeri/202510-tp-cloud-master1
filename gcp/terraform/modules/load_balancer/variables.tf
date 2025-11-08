variable "project_id" {
  type = string
}

variable "enable" {
  type    = bool
  default = false
}

variable "name_prefix" {
  type    = string
  default = "tpcloud-lb"
}

variable "bucket_name" {
  type    = string
  default = ""
}

variable "ssl_certificate_self_links" {
  type    = list(string)
  default = []
}

variable "managed_certificate_domains" {
  type = list(string)
  default = []
  description = "Optional list of domain names for which a Google-managed SSL certificate should be requested. If set, a managed certificate will be created and attached to the HTTPS proxy (requires DNS to be configured for the domains)."
}

variable "manage_dns_records" {
  type    = bool
  default = false
  description = "If true, the module will create A records in Cloud DNS for each domain in managed_certificate_domains pointing at the LB IP. Requires 'managed_zone' to be set and DNS API enabled."
}

variable "managed_zone" {
  type    = string
  default = ""
  description = "Name of the Cloud DNS managed zone to create records in (required when manage_dns_records = true)."
}

variable "backend_instance_group_self_link" {
  type    = string
  default = ""
  description = "Optional instance group self_link to use as backend"
}

variable "attach_cloud_armor_policy" {
  type    = bool
  default = false
  description = "If true, attach `cloud_armor_policy_self_link` to the backend service"
}

variable "cloud_armor_policy_self_link" {
  type    = string
  default = ""
  description = "Self link of the Cloud Armor security policy to attach to the backend service"
}

variable "enable_backend_service" {
  type    = bool
  default = false
  description = "If true, create a backend_service using `backend_instance_group_self_link` as group"
}
