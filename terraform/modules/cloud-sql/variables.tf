variable "region_name" {
  type        = string
  description = "Region name"
}

variable "zone_name" {
  type        = string
  description = "Zone name"
}

variable "project_id" {
  type        = string
  description = "Project Id"
  default     = "project-18ee516c-a108-431d-a73"
}

variable "network_self_link" {
  type        = string
  description = "Network Self link"
}

variable "instance_name" {
  type        = string
  description = "Instance name"
  # default = "postgres-dev"
}

variable "database_name" {
  type        = string
  description = "Database name"
  # default = "votingapp"
}

variable "db_version" {
  type        = string
  description = "DB Version"
  # default = "POSTGRES_16"
}

variable "db_tier" {
  type        = string
  description = "DB Tier"
  # default = "db-custom-2-8192"
}