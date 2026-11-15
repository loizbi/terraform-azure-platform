
output "resource_group_name" {
  value = azurerm_resource_group.vnet_rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  value = var.vnet_address_space
}

output "subnet_name" {
  value = azurerm_subnet.internal.name
}

output "subnet_address_prefix" {
  value = var.subnet_address_prefix
}
