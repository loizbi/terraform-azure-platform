

output "vm_rg" {
  description = "Virtual machine resource group name"
  value       = azurerm_resource_group.vms_rg.name
}

output "vm_name" {
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

output "vm_nic_name" {
  description = "Names of the VM network interfaces"
  value       = azurerm_network_interface.vms_nic[*].name
}

output "vm_nic_private_ip" {
  description = "Private IP addresses of the VM network interfaces"
  value       = azurerm_network_interface.vms_nic[*].private_ip_address
}

output "vm_public_ip" {
  description = "Public IP addresses of the virtual machines"
  value       = azurerm_public_ip.vms_public_ip[*].ip_address
}

output "vm_dns_record" {
  description = "DNS records of the virtual machines"
  value       = azurerm_dns_a_record.vms_dns_record[*].fqdn
}