resource "google_sql_database_instance" "this" {
  name             = var.instance_name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  settings {
    tier = var.tier

    availability_type = var.availability_type

    backup_configuration {
      enabled = var.backup_enabled
      start_time = var.backup_start_time
    }

    ip_configuration {
      # Support either private IP (peered VPC) or public IPv4 depending on module input.
      ipv4_enabled = var.use_private_network ? false : true
      require_ssl  = var.use_private_network ? true  : false

      # Only set private_network when requested. When using public IPv4 do not set this.
      private_network = var.use_private_network ? var.network_self_link : null
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "default_db" {
  instance = google_sql_database_instance.this.name
  name     = var.database_name
}

# Optional DB user creation and Secret Manager integration (opt-in)
resource "random_password" "db" {
  count   = var.create_secret && length(trimspace(var.db_password)) == 0 ? 1 : 0
  length  = 16
  special = true
}

resource "google_secret_manager_secret" "db_password" {
  count     = var.create_secret ? 1 : 0
  project   = var.project_id
  secret_id = "${var.instance_name}-db-password"

  replication {
    auto = {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  count       = var.create_secret ? 1 : 0
  secret      = google_secret_manager_secret.db_password[0].id
  secret_data = length(trimspace(var.db_password)) > 0 ? var.db_password : random_password.db[0].result
}

# If a service account email is provided, grant it access to the created secret so VMs can fetch the DB password.
resource "google_secret_manager_secret_iam_member" "allow_instance_sa" {
  count     = var.create_secret ? 1 : 0
  secret_id = google_secret_manager_secret.db_password[0].secret_id
  project   = var.project_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.instance_service_account_email}"
}

# Create a database user if requested. Password is taken from db_password (if provided) or from the generated random_password.
resource "google_sql_user" "db_user" {
  count    = var.db_user_create && (length(trimspace(var.db_password)) > 0 || var.create_secret) ? 1 : 0
  name     = var.db_user_name
  project  = var.project_id
  instance = google_sql_database_instance.this.name

  password = length(trimspace(var.db_password)) > 0 ? var.db_password : random_password.db[0].result
}

