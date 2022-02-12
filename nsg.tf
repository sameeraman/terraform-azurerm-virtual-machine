resource "azurerm_network_security_group" "vm_nsg1" {
  count               = var.apply_default_nsg == true ? 1 : 0
  name                = "${var.virtual_machine_name}-nic1-nsg1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

}


resource "azurerm_network_interface_security_group_association" "nsg_association" {
  count                     = var.apply_default_nsg == true ? 1 : 0
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.vm_nsg1[0].id
}


resource "azurerm_network_security_rule" "rule1" {
  count                       = var.allow_management_ports == true ? 1 : 0
  name                        = "allow_management_ports"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = substr(lower(var.virtual_machine_os), 0, 5) == "windo" ? "3389" : "22"
  source_address_prefixes     = split(",", var.allowed_inbound_public_ips)
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.vm_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg1[0].name
}
