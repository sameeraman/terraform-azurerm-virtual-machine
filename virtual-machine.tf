resource "azurerm_network_interface" "nic1" {
  name                = "${var.virtual_machine_name}-nic1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip == true ? azurerm_public_ip.pip1[0].id : null
  }

  tags = merge(var.tags, { CreatedOn = timestamp() })

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
    ]
  }
}


# Create Windows VM if the OS Type is Windows-SQL or Windows
resource "azurerm_windows_virtual_machine" "vm1" {
  count                 = local.windows_count
  name                  = var.virtual_machine_name
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.vm_rg.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  size                  = var.virtual_machine_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  license_type          = var.activate_ahb == true ? "Windows_Server" : "None"

  source_image_reference {
    publisher = lower(var.virtual_machine_os) == "windows-sql" ? "MicrosoftSQLServer" : "MicrosoftWindowsServer"
    offer     = lower(var.virtual_machine_os) == "windows-sql" ? "SQL2016SP1-WS2016" : "WindowsServer"
    sku       = lower(var.virtual_machine_os) == "windows-sql" ? "Standard" : "2019-Datacenter-smalldisk"
    version   = lower(var.virtual_machine_os) == "windows-sql" ? "13.2.211109" : "latest"
  }

  os_disk {
    name                 = "${var.virtual_machine_name}-disk1"
    caching              = "ReadWrite"
    storage_account_type = var.virtual_machine_disk_type
  }

  tags = merge(var.tags, { CreatedOn = timestamp() })

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
    ]
  }
}


# Create Ubuntu VM if the OS Type is Linux
resource "azurerm_linux_virtual_machine" "vm1" {
  count                           = local.linux_count
  name                            = var.virtual_machine_name
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.vm_rg.name
  network_interface_ids           = [azurerm_network_interface.nic1.id]
  size                            = var.virtual_machine_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.virtual_machine_name}-disk1"
    caching              = "ReadWrite"
    storage_account_type = var.virtual_machine_disk_type
  }

  tags = merge(var.tags, { CreatedOn = timestamp() })

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
    ]
  }
}


resource "azurerm_public_ip" "pip1" {
  count               = var.enable_public_ip == true ? 1 : 0
  name                = "${var.virtual_machine_name}-pip1"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = merge(var.tags, { CreatedOn = timestamp() })

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
    ]
  }
}
