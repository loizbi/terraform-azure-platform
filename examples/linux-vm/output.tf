
output "resource_group_name" {
  value = module.azure-networking.resource_group_name
}

output "vnet_name" {
  value = module.azure-networking.vnet_name
}

output "vnet_address_space" {
  value = var.vnet_address_space
}

output "subnet_name" {
  value = module.azure-networking.subnet_name
}

output "subnet_address_prefix" {
  value = var.subnet_address_prefix
}
