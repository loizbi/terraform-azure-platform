
# Use the networking module
module "networking" { 
  # Recommended to use full commit SHA
  source = "git::https://github.com/loizbi/terraform-azure-platform.git//modules/networking?ref=validation"

  ## Environment-specific variables
  location    = var.location
  team        = var.team
  environment = var.environment

  ## Resource-specific variables
  project               = var.project
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
}

# Use the Linux VM module
module "linux_vm" {
  # Recommended to use full commit SHA
  source = "git::https://github.com/loizbi/terraform-azure-platform.git//modules/linux-vm?ref=validation"
  
  ## Environment-specific variables
  location    = var.location
  team        = var.team
  environment = var.environment
  domain      = var.domain
  domain_rg   = var.domain_rg

  ## Pass from networking module
  subnet_id = module.networking.subnet_id

  ## Resource-specific variables
  project = var.project
  image_reference     = var.image_reference
  vm_type             = var.vm_type
  vm_name             = var.vm_name
  vm_username         = var.vm_username
  vm_count            = var.vm_count
  
  ## SSH & Security
  ssh_public_key_name = var.ssh_public_key_name
  ssh_public_key_rg   = var.ssh_public_key_rg
  vm_allowed_ips      = var.vm_allowed_ips
}