Module Cloud SQL — Postgres

Description
- Provisionne une instance Cloud SQL (Postgres) avec options pour IP privée (VPC peering), sauvegardes et stockage du mot de passe dans Secret Manager.

Prérequis
- API Cloud SQL et Service Networking activées. Si vous utilisez IP privée, réservez un /24 interne pour le peering.

Variables principales
- `project_id`, `region`.
- `instance_name` — nom de l'instance (défaut : `tpcloud-db`).
- `database_name`, `database_version`, `tier`, `availability_type`.
- `use_private_network` (bool) — si true, configure l'instance en IP privée via Service Networking.
- `db_user_create`, `db_user_name`, `db_password` (sensible), `create_secret` (bool) pour Secret Manager.
- `network_self_link` : self_link du réseau pour la configuration privée.

Outputs
- `instance_connection_name` : connection name (projet:region:instance) pour connecter un client.
- `instance_self_link` : self_link de l'instance.

Exemple d'utilisation
module "cloud_sql" {
  source     = "../modules/cloud_sql"
  project_id = var.project_id
  region     = "us-central1"
  use_private_network = true
  create_secret = true
}

Notes & permissions
- Nécessite `roles/cloudsql.admin` et `roles/servicenetworking.networksAdmin` pour la configuration IP privée. Les changements réseau peuvent déclencher des recréations selon le provider.


Purpose
- Provision a Cloud SQL (Postgres) instance, optionally with private IP and an associated Secret Manager secret for the DB password.

Inputs
- project_id (string)
- region (string)
- instance_name (string) default: "tpcloud-db"
- database_name (string) default: "tpcloud"
- database_version (string) default: "POSTGRES_13"
- tier (string) default: "db-f1-micro"
- availability_type (string) default: "REGIONAL"
- backup_enabled (bool) default: true
- backup_start_time (string) default: "03:00"
- network_self_link (string)
- use_private_network (bool) default: true
- deletion_protection (bool) default: false
- db_user_name (string) default: "tpcloud"
- db_user_create (bool) default: true
- db_password (string, sensitive)
- create_secret (bool) default: false
- instance_service_account_email (string)

Outputs
- instance_connection_name
- instance_self_link

Example
module "cloud_sql" {
  source     = "../modules/cloud_sql"
  project_id = var.project_id
  region     = "us-central1"
}
# Cloud SQL module

This module provisions a Cloud SQL instance and a default database. It supports either public IPv4 or private IP (VPC peering) access.

Important
- The module accepts `use_private_network` (bool). When set to true the root module must create a reserved internal IP range and a
  `google_service_networking_connection` (Service Networking) to peer the VPC with Google services. The root module in this repository
  already implements that guarded resource when `cloud_sql_use_private_network = true`.
- Private IP path requires:
  1. A reserved internal IP range (google_compute_global_address with purpose = "VPC_PEERING").
  2. A `google_service_networking_connection` referencing the reserved range.
  3. Time for the peering to become active before the instance can be switched to private IP.

Notes
- In-place updates to switch public -> private may succeed (as in this session) but in some cases recreations may occur depending on Cloud SQL
  behavior and provider versions. Always keep backups if switching networking modes on production instances.

Usage example (root `terraform.tfvars`):

enable_cloud_sql = true
cloud_sql_instance_name = "tpcloud-db"
cloud_sql_database_name = "tpcloud"
cloud_sql_use_private_network = true
