
variable "location" {
  description = "Region for the resource creation"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "team" {
  description = "Team Name"
  type        = string
}

variable "project" {
  description = "Project Name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
}
