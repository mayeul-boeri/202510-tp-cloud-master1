output "crypto_key_id" {
  value = google_kms_crypto_key.this.id
}

# note: crypto_key.self_link not available in this provider version; use id where needed
