output "instance_connection_name" {
  value = google_sql_database_instance.this.connection_name
}

output "instance_self_link" {
  value = google_sql_database_instance.this.self_link
}
