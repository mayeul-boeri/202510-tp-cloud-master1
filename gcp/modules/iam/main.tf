resource "google_service_account" "instance_sa" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-instance-sa"
  display_name = "Instance service account for ${var.name_prefix}"
}

resource "google_service_account" "deployer_sa" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-deployer-sa"
  display_name = "Deployer service account for ${var.name_prefix}"
}
