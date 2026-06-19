resource "google_project_service" "sqladmin" {
  project            = var.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_sql_database_instance" "postgres" {

  name             = var.instance_name
  region           = var.region_name
  database_version = var.db_version

  deletion_protection = false

  depends_on = [
    google_project_service.sqladmin
  ]

  settings {
    edition = "ENTERPRISE"
    tier              = var.db_tier
    availability_type = "REGIONAL"

    disk_type       = "PD_SSD"
    disk_size       = 20
    disk_autoresize = true

    activation_policy = "ALWAYS"

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }

    insights_config {
      query_insights_enabled = true
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.network_self_link
      enable_private_path_for_google_cloud_services = true
    }

    maintenance_window {
      day  = 7
      hour = 2
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
  }
}

resource "google_sql_database" "votingapp" {
  name     = "votingapp"
  instance = google_sql_database_instance.postgres.name
}