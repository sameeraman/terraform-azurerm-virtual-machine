
output "name" {
  description = "virtual machine name"
  value       = var.virtual_machine_name
}
output "resource_group_name" {
  description = "virtual machine resource group name"
  value       = var.virtual_machine_rg_name
}

output "nic_id" {
  description = "virtual machine nic id"
  value       = azurerm_network_interface.nic1.id
}

output "vm_admin_username" {
  description = "virtual machine administrator username"
  value       = var.admin_username
}

output "vm_admin_password" {
  description = "virtual machine administrator password"
  value       = var.admin_password
}

output "vm_id" {
  description = "virtual machine id"
  value       = var.virtual_machine_os == "linux" ? azurerm_linux_virtual_machine.vm1[0].id : azurerm_windows_virtual_machine.vm1[0].id
}