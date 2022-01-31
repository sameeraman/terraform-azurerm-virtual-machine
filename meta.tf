locals {
  linux_count   = lower(var.virtual_machine_os) == "linux" ? 1 : 0
  windows_count = lower(var.virtual_machine_os) == "windows" ? 1 : 0
  windows_sql_count = lower(var.virtual_machine_os) == "windows-sql" ? 1 : 0
}


data "azurerm_client_config" "current" {
}
# Existing Subnet
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_rg_name
}

# Existing Resource group for the VM
data "azurerm_resource_group" "vm_rg" {
  name = var.virtual_machine_rg_name
}
