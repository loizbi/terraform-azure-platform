
variable "location" {
  description = "Region for the resource creation"
  type        = string
}

variable "environment" {
  description = "Custom Project UID"
  type        = string
}

variable "team" {
  description = "Team Name"
  type        = string
}

variable "domain" {
  description = "Domain name for the project"
  type        = string
}

variable "domain_rg" {
  description = "Resource group for the domain"
  type        = string
}

variable "project" {
  description = "Project's Name"
  type        = string
}

variable "vnet_rg" {
  description = "Name"
  type        = string
}

variable "vnet_name" {
  description = "Name"
  type        = string
}

variable "subnet_name" {
  description = "Name"
  type        = string
}

variable "image_reference" {
  description = "Name"
  type        = list(string)
}

variable "vm_type" {
  description = "Type of the virtual machine"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_username" {
  description = "Username for the virtual machine"
  type        = string
}

variable "ssh_public_key_name" {
  description = "SSH Public Key Name"
  type        = string
}

variable "ssh_public_key_rg" {
  description = "SSH Public Key Name Resource Group"
  type        = string
}

variable "vm_allowed_ips" {
  description = "List of allowed IP addresses"
  type        = list(string)
}

variable "vm_count" {
  description = "Number of VM instances to create"
  type        = number
  nullable    = false

  validation {
    condition     = var.vm_count >= 1 && floor(var.vm_count) == var.vm_count
    error_message = "The vm_count value must be a positive whole number."
  }
}