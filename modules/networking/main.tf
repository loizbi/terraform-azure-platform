
resource "azurerm_resource_group" "vnet_rg" {
  name     = "${var.project}-${var.environment}-${var.location}-rg"
  location = var.location

  # Merging common tags with resource-specific tags
  tags = merge(local.common_tags, {
    Project = var.project
  })
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-${var.environment}-${var.location}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  # Merging common tags with resource-specific tags
  tags = merge(local.common_tags, {
    Project = var.project
  })
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.project}-${var.environment}-${var.location}-subnet"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}