
# Use the networking module
module "azure-networking" {
  source = "git::https://github.com/loizbi/terraform-azure-platform.git//modules/networking?ref=c55413df7ca6a20be8a41a18447590881e552cc0"

  ### Pass variables to the module ###

  # Environment-specific variables
  location    = var.location
  team        = var.team
  environment = var.environment

  # Resource-specific variables
  project               = var.project
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
}