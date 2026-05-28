variable "project_id" {
  type        = string
  description = "Project Id"
  default     = "project-18ee516c-a108-431d-a73"
}

variable "region_name" {
  type        = string
  description = "Region name"
}

variable "zone_name" {
  type        = string
  description = "Zone name"
}

# variables for service account for github actions 
variable "github_org" {
  type        = string
  description = "Github organization"
}

variable "github_repo" {
  type        = string
  description = "Github repo name"
}

variable "pool_id" {
  type        = string
  description = "Pool ID"
}

variable "provider_id" {
  type        = string
  description = "Provider ID"
}

variable "service_account_id" {
  type        = string
  description = "Github actions service account id"
}

variable "artifact_registry_role" {
  type        = string
  description = "Roles for artifact registry"
}