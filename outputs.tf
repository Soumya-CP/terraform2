output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.infosolution.name
}

output "vm_name" {
  description = "Name of the created VM."
  value       = azurerm_linux_virtual_machine.infosolution.name
}

output "public_ip_address" {
  description = "Public IP address of the VM."
  value       = azurerm_public_ip.infosolution.ip_address
}

output "ssh_command" {
  description = "Command to connect to the VM after deployment."
  value       = "ssh -i infosolution-vm.pem ${var.admin_username}@${azurerm_public_ip.infosolution.ip_address}"
}
