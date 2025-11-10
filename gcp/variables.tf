variable "project_id" {
  type        = string
  description = "GCP project id to deploy into"
}

variable "enable_storage" {
  type    = bool
  default = false
  description = "Enable provisioning of a Cloud Storage bucket via modules/storage"
}

variable "storage_bucket_name" {
  type    = string
  default = ""
  description = "Name of the Storage bucket to create (must be globally unique)."
}

variable "enable_load_balancer" {
  type    = bool
  default = false
  description = "Enable the HTTPS load balancer scaffold (modules/load_balancer)"
}

variable "load_balancer_name_prefix" {
  type    = string
  default = "tpcloud-lb"
  description = "Prefix used for load balancer resources"
}

variable "load_balancer_bucket_name" {
  type    = string
  default = ""
  description = "Optional backend bucket name for the scaffolded load balancer"
}

variable "load_balancer_ssl_certificates" {
  type    = list(string)
  default = []
  description = "List of SSL certificate self_links to attach to the HTTPS proxy"
}

variable "enable_instance_group" {
  type    = bool
  default = false
  description = "Enable the instance group scaffold to be used as LB backend"
}

variable "instance_group_count" {
  type    = number
  default = 1
}

variable "instance_group_machine_type" {
  type    = string
  default = "e2-micro"
}

variable "instance_group_image" {
  type    = string
  default = "projects/debian-cloud/global/images/family/debian-11"
}

# Instance group / autoscaling / healthcheck variables (mapped to module.instance_group)
variable "instance_group_name_prefix" {
  type    = string
  default = "tpcloud-lb"
}

variable "instance_group_enable_autoscaling" {
  type    = bool
  default = false
}

variable "instance_group_autoscaling_min_replicas" {
  type    = number
  default = 1
}

variable "instance_group_autoscaling_max_replicas" {
  type    = number
  default = 3
}

variable "instance_group_autoscaling_cpu_target" {
  type    = number
  default = 0.6
}

variable "instance_group_enable_health_check" {
  type    = bool
  default = false
}

variable "instance_group_auto_healing_initial_delay" {
  type    = number
  default = 300
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "enable_cloud_sql" {
  type    = bool
  default = false
}

variable "cloud_sql_use_private_network" {
  type    = bool
  default = false
  description = "If true, create Service Networking peering and configure Cloud SQL with a private IP on the VPC network."
}

variable "cloud_sql_instance_name" {
  type    = string
  default = "tpcloud-db"
}

variable "cloud_sql_database_name" {
  type    = string
  default = "tpcloud"
}

variable "enable_kms" {
  type    = bool
  default = false
  description = "Enable creation of a KMS key ring and crypto key for CMEK usage."
}

variable "kms_location" {
  type    = string
  default = "us-central1"
  description = "Location for the KMS key ring and crypto key."
}

variable "enable_monitoring" {
  type    = bool
  default = false
  description = "Enable provisioning of monitoring resources (notification channels/uptime checks)"
}

variable "monitoring_notification_email" {
  type    = string
  default = ""
  description = "Email address to use for a notification channel when monitoring is enabled."
}

variable "create_secret" {
  type    = bool
  default = false
  description = "If true, create a Secret Manager secret for the Cloud SQL user password (opt-in)."
}

variable "db_user_create" {
  type    = bool
  default = true
  description = "Whether to create a database user for the Cloud SQL instance."
}

variable "db_password" {
  type      = string
  default   = ""
  sensitive = true
  description = "Optional DB user password. If empty and create_secret is true, a random password will be generated and stored in Secret Manager."
}

variable "region" {
  type        = string
  description = "Primary region for resources"
  default     = "us-central1"
}

variable "network_name" {
  type        = string
  description = "Name for the VPC network"
  default     = "tpcloud-gcp-vpc"
}

variable "subnets" {
  description = "List of subnets to create. Each item must include: name, ip_cidr_range, region, private (bool)"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
    private       = bool
  }))
  default = [
    {
      name          = "private-subnet-1"
      ip_cidr_range = "10.10.1.0/24"
      region        = "us-central1"
      private       = true
    },
    {
      name          = "public-subnet-1"
      ip_cidr_range = "10.10.2.0/24"
      region        = "us-central1"
      private       = false
    }
  ]
}

variable "instance_group_startup_script" {
  type        = string
  default     = ""
  description = "Startup script (bash) to run on instance templates for the instance group. Use to install nginx or your app."
}

