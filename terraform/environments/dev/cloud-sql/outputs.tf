output "instance_name" {
  value = module.cloud_sql.instance_name
}

output "private_ip" {
  value = module.cloud_sql.private_ip
}

output "connection_name" {
  value = module.cloud_sql.connection_name
}

output "db_name" {
  value = module.cloud_sql.db_name
}

output "self_link" {
  value = module.cloud_sql.self_link # google_sql_database.votingapp.self_link
}