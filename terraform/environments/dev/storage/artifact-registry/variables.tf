variable "project_id" {
  type        = string
  description = "Project ID"
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

variable "repository_name" {
  type        = string
  description = "Repository name"
}

variable "repository_description" {
  type        = string
  description = "Repository description"
}

variable "repository_format" {
  type        = string
  description = "Repository format"
}

variable "platform_repository_name" {
  type        = string
  description = "Platform repository name"
}

variable "platform_repository_description" {
  type        = string
  description = "Platform repository for storing docker's"
}

variable "platform_repository_format" {
  type        = string
  description = "Platform repository format"
}