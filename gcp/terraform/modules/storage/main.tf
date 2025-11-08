resource "google_storage_bucket" "this" {
  name                        = var.name
  project                     = var.project_id
  location                    = var.location
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = var.lifecycle_days
    }
  }

  dynamic "encryption" {
    for_each = var.kms_key_name == "" ? [] : [var.kms_key_name]
    content {
      default_kms_key_name = encryption.value
    }
  }
}
