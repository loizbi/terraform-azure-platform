variable "region" {
  description = "Region for the resource creation"
  type        = string
}

variable "environment" {
  description = "Custom Project UID"
  type        = string
}

variable "project" {
  description = "Project's Name"
  type        = string
}

variable "storage_container" {
  description = "Storage Container Name"
  type        = string
}

variable "admin_object_id" {
  description = "Microsoft Entra ID SG object ID of the backend administrators"
  type        = string
}