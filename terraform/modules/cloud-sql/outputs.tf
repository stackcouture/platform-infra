output "instance_name" {
  value = google_sql_database_instance.postgres.name
}

output "private_ip" {
  value = google_sql_database_instance.postgres.private_ip_address
}

output "connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}

output "self_link" {
  value = google_sql_database.votingapp.self_link
}

output "db_name" {
  value = google_sql_database.votingapp.name
}