
# Retrieve existing SSH public key from Azure
data "azurerm_ssh_public_key" "ssh_key" {
  name                = var.ssh_public_key_name
  resource_group_name = var.ssh_public_key_rg
}

# Retrieve existing SSH public key from Azure
data "azurerm_dns_zone" "dns_zone" {
  name                = "${var.environment}.${var.domain}"
  resource_group_name = var.domain_rg
}

resource "azurerm_resource_group" "vms_rg" {
  name     = "${var.project}-${var.environment}-${var.location}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vms_vnet" {
  name                = "${var.project}-${var.environment}-${var.location}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vms_rg.location
  resource_group_name = azurerm_resource_group.vms_rg.name
}

resource "azurerm_subnet" "vms_internal" {
  name                 = "${var.project}-${var.environment}-${var.location}-subnet"
  resource_group_name  = azurerm_resource_group.vms_rg.name
  virtual_network_name = azurerm_virtual_network.vms_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vms_nic" {
  count = var.vm_count

  name                = "${var.project}-${var.environment}-${var.location}-nic-${count.index + 1}"
  location            = azurerm_resource_group.vms_rg.location
  resource_group_name = azurerm_resource_group.vms_rg.name

  ip_configuration {
    name                          = "ip-${count.index + 1}"
    subnet_id                     = azurerm_subnet.vms_internal.id
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
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  storage_os_disk {
    name              = "os-disk-${count.index + 1}"
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
}

resource "azurerm_network_security_group" "vms_nsg" {
  name                = "${var.project}-${var.environment}-nsg"
  location            = azurerm_resource_group.vms_rg.location
  resource_group_name = azurerm_resource_group.vms_rg.name

  security_rule {
    name                         = "Allow-SSH"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefixes      = var.vm_allowed_ips
    destination_address_prefix   = "*"
  }

  security_rule {
    name                         = "Allow-HTTP"
    priority                     = 110
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "80"
    source_address_prefixes      = ["0.0.0.0/0"]
    destination_address_prefix   = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "vms_nsg_association" {
  subnet_id                 = azurerm_subnet.vms_internal.id
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