
# Use the networking module
module "networking" {
  source = "git::https://github.com/loizbi/terraform-azure-platform.git//modules/networking?ref=c55413df7ca6a20be8a41a18447590881e552cc0"

  ## Pass variables to the module

  # Environment-specific variables
  location    = var.location
  team        = var.team
  environment = var.environment

  # Resource-specific variables
  project               = var.project
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
}

# Use the linux vm module
module "linux_vm" {
  source = "git::https://github.com/loizbi/terraform-azure-platform.git//modules/linux-vm?ref=c55413df7ca6a20be8a41a18447590881e552cc0"

  ## Pass variables to the module

  # Environment-specific variables
  location    = var.location
  team        = var.team
  environment = var.environment
  domain      = var.domain
  domain_rg   = var.domain_rg

  # Resource-specific variables
  project = var.project

  # Pass from networking module
  vnet_rg     = module.networking.vnet_rg
  vnet_name   = module.networking.vnet_name
  subnet_name = module.networking.subnet_id

  image_reference     = var.image_reference
  vm_type             = var.vm_type
  vm_name             = var.vm_name
  ssh_public_key_name = var.ssh_public_key_name
  ssh_public_key_rg   = var.ssh_public_key_rg
  vm_username         = var.vm_username
  vm_count            = var.vm_cound
  vm_allowed_ips      = var.vm_allowed_ips




}