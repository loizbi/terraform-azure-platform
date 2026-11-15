
# Retrieve existing DNS zone from Azure
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

# Retrieve existing SSH public key from Azure
data "azurerm_ssh_public_key" "ssh_key" {
  name                = var.ssh_public_key_name
  resource_group_name = var.ssh_public_key_rg
}

# Retrieve existing DNS zone from Azure
data "azurerm_dns_zone" "dns_zone" {
  name                = "${var.environment}.${var.domain}"
  resource_group_name = var.domain_rg
}

resource "azurerm_resource_group" "vms_rg" {
  name     = "${var.project}-${var.environment}-${var.location}-rg"
  location = var.location

  # Merging common tags with resource-specific tags
  tags = merge(local.common_tags, {
    Project = var.project
  })
}

resource "azurerm_network_interface" "vms_nic" {
  count = var.vm_count

  name                = "${var.project}-${var.environment}-${var.location}-nic-${count.index + 1}"
  location            = azurerm_resource_group.vms_rg.location
  resource_group_name = azurerm_resource_group.vms_rg.name

  ip_configuration {
    name                          = "ip-${count.index + 1}"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.vms_public_ip[count.index].id
  }
}

resource "azurerm_public_ip" "vms_public_ip" {
  count = var.vm_count

  name                = "${var.project}-${var.environment}-${var.location}-pip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.vms_rg.name
  location            = azurerm_resource_group.vms_rg.location

  allocation_method = "Static"
  sku               = "Standard"

  zones = [tostring((count.index % 3) + 1)]
}

resource "azurerm_virtual_machine" "vms_vm" {
  count = var.vm_count

  name                  = "${var.vm_name}-${count.index + 1}"
  location              = azurerm_resource_group.vms_rg.location
  resource_group_name   = azurerm_resource_group.vms_rg.name
  network_interface_ids = [azurerm_network_interface.vms_nic[count.index].id]
  vm_size               = var.vm_type

  zones = [tostring((count.index % 3) + 1)]

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.image_reference[0]
    offer     = var.image_reference[1]
    sku       = var.image_reference[2]
    version   = var.image_reference[3]
  }

  storage_os_disk {
    name              = "os-disk-${var.vm_name}-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.vm_name}-${count.index + 1}"
    admin_username = var.vm_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_username}/.ssh/authorized_keys"
      key_data = data.azurerm_ssh_public_key.ssh_key.public_key
    }
  }

  lifecycle {
    prevent_destroy = false
  }

}

resource "azurerm_network_security_group" "vms_nsg" {
  name                = "${var.project}-${var.environment}-nsg"
  location            = azurerm_resource_group.vms_rg.location
  resource_group_name = azurerm_resource_group.vms_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.vm_allowed_ips
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = ["0.0.0.0/0"]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "vms_nsg_association" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.vms_nsg.id
}

resource "azurerm_dns_a_record" "vms_dns_record" {
  count = var.vm_count

  name                = "${var.vm_name}-${count.index + 1}"
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = var.domain_rg
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.vms_public_ip[count.index].id
}