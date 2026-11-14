

output "resource_group_name" {
  description = "Virtual machine resource group name"
  value       = azurerm_resource_group.vms_rg.name
}

output "vms_names" {
  description = "Names of the virtual machines"
  value       = azurerm_virtual_machine.vms_vm[*].name
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = var.vnet_name
}

output "subnet_name" {
  description = "Name of the virtual machine subnet"
  value       = var.subnet_name
}

output "vms_nics_names" {
  description = "Names of the VM network interfaces"
  value       = azurerm_network_interface.vms_nic[*].name
}

output "vms_nics_private_ip" {
  description = "Private IP addresses of the VM network interfaces"
  value       = azurerm_network_interface.vms_nic[*].private_ip_address
}

output "vms_public_ip_addresses" {
  description = "Public IP addresses of the virtual machines"
  value       = azurerm_public_ip.vms_public_ip[*].ip_address
}

output "vms_dns_records" {
  description = "DNS records of the virtual machines"
  value       = azurerm_dns_a_record.vms_dns_record[*].fqdn
}