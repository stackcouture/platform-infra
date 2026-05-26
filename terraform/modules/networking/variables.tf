# VPC Settings 
variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "Auto Create Subnetworks settings"
}

variable "routing_mode" {
  type        = string
  description = "Routing Mode"
}

# Subnetwork 
variable "subnetwork_name" {
  type        = string
  description = "Private Subnet"
}

variable "subnetwork_ip_cidr_range" {
  type        = string
  description = "Subnetwork IP CIDR Range"
}

variable "region_name" {
  type        = string
  description = "Subnetwork region"
}

# Firewall variables
variable "allow_internal_firewall_rule_name" {
  type        = string
  description = "Internal Firewall Rule name"
  default     = null
}

variable "allow_external_firewall_rule_name" {
  type        = string
  description = "Internal Firewall Rule name"
  default     = null
}

variable "allow_gke_rule_name" {
  type        = string
  description = "GKE Firewall Rule name"
  default     = null
}