
# Networking module
output "vnet_rg" {
  value = module.networking.vnet_rg
}

output "vnet_name" {
  value = module.networking.vnet_name
}

output "vnet_address_space" {
  value = var.vnet_address_space
}

output "subnet_name" {
  value = module.networking.subnet_name
}

output "subnet_id" {
  value = module.networking.subnet_id
}

output "subnet_address_prefix" {
  value = var.subnet_address_prefix
}

# Linux VM module

output "vm_rg" {
  description = "Virtual machine resource group name"
  value       = module.linux_vm.vm_rg
}

output "vm_name" {
  description = "Names of the virtual machines"
  value       = module.linux_vm.vm_name
}

output "vm_nic_name" {
  description = "Names of the VM network interfaces"
  value       = module.linux_vm.vm_nic_name
}

output "vm_nic_private_ip" {
  description = "Private IP addresses of the VM network interfaces"
  value       = module.linux_vm.vm_nic_private_ip
}

output "vm_public_ip" {
  description = "Public IP addresses of the virtual machines"
  value       = module.linux_vm.vm_public_ip
}

output "vm_dns_record" {
  description = "DNS records of the virtual machines"
  value       = module.linux_vm.vm_dns_record
}