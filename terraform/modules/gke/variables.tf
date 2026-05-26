variable "compute_network_name" {
  type        = string
  description = "VPC Compute Network Name"
}

variable "compute_subnetwork_name" {
  type        = string
  description = "VPC Subnetwork Name"
}

variable "initial_node_count" {
  type        = number
  description = "Initial Node Count"
}

variable "deletion_protection" {
  type        = bool
  description = "Deleteion Protection"
}

variable "remove_default_node_pool" {
  type        = bool
  description = "Default Node Pool Remove"
}

variable "location_name" {
  type        = string
  description = "Location Name"
}

variable "sa_node_email" {
  type        = string
  description = "SA Node Email"
}

variable "project_id" {
  type        = string
  description = "Project Id"
  default     = "project-18ee516c-a108-431d-a73"
}