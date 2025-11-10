output "instance_service_account_email" {
  value = google_service_account.instance_sa.email
}

output "deployer_service_account_email" {
  value = google_service_account.deployer_sa.email
}
