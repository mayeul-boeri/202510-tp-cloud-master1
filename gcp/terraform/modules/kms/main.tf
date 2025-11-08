resource "google_kms_key_ring" "this" {
  name     = "${var.name_prefix}-kr"
  location = var.location
  project  = var.project_id
}

resource "google_kms_crypto_key" "this" {
  name            = "${var.name_prefix}-key"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "7776000s" # 90 days

  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
  }
}
