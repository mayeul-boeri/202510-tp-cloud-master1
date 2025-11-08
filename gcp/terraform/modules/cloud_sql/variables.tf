variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "instance_name" {
  type    = string
  default = "tpcloud-db"
}

variable "database_name" {
  type    = string
  default = "tpcloud"
}

variable "database_version" {
  type    = string
  default = "POSTGRES_13"
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "backup_enabled" {
  type    = bool
  default = true
}

variable "backup_start_time" {
  type    = string
  default = "03:00"
}

variable "network_self_link" {
  type = string
}

variable "use_private_network" {
  type    = bool
  default = true
  description = "If true, configure Cloud SQL with private IP on the provided network_self_link. If false, enable public IPv4 for the instance."
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "db_user_name" {
  type    = string
  default = "tpcloud"
  description = "Name of the Cloud SQL user to create for the application. The module will create this user if db_user_create is true."
}

variable "db_user_create" {
  type    = bool
  default = true
  description = "Whether to create the database user (google_sql_user)."
}

variable "db_password" {
  type        = string
  default     = ""
  description = "Optional password for the database user. If empty and create_secret is true, a random password will be generated and optionally stored in Secret Manager."
  sensitive   = true
}

variable "create_secret" {
  type    = bool
  default = false
  description = "If true, create a Secret Manager secret containing the DB password (random or provided)."
}

variable "instance_service_account_email" {
  type    = string
  default = ""
  description = "Optional: email of a service account (eg. VM's service account) to grant Secret Manager access so it can read the DB password."
}
