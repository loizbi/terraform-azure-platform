
output "region" {
  value = var.region
}

output "azurerm_resource_group" {
  value = azurerm_resource_group.tfstate.name
}

output "azurerm_storage_account" {
  value = azurerm_storage_account.tfstate.name
}

output "azurerm_storage_container" {
  value = azurerm_storage_container.tfstate.name
}