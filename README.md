# terraform-azurerm-virtual-machine
This repo provides a terraform module to create a Virtual Machine in Azure. It has the following built in defaults. 
* Windows 2019, SQL Server 2016 SP1 or Ubunutu 16.04 image support, default : Ubuntu
* Does not create a public IP by default
* Small OS disk size by default
* Uses Premium Disk by default
* Uses `Standard_B2ms` size for testing purposes
* Uses `azureadmin` as the default admin username

## Example Usage
Example 1

```tf
module "naming" {
  source              = "github.com/sameeraman/terraform-azurerm-naming"
  company-prefix      = "fbk"
  region-prefix       = "use1"
  environment-prefix  = "prd"
}

module "rg1" {
  source     = "github.com/sameeraman/terraform-azurerm-resource-group"

  name       = join("-", [module.naming.resource_group.name,"001"])
  location   = var.location
  tags       = var.tags
}

resource "azurerm_virtual_network" "vnet1" {
  name                = join("-", [module.naming.virtual_network.name,"001"])
  location            = var.location
  resource_group_name = module.rg1.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "server" {
  name                 = "Server"
  resource_group_name  = module.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

module "virtual-machine" {
  source = "github.com/sameeraman/terraform-azurerm-virtual-machine?ref=v1.0.0"

  virtual_machine_name        = join("", [module.naming.windows_virtual_machine.name,"01"])
  virtual_machine_rg_name     = module.rg1.name
  tags                        = var.tags
  location                    = var.location
  virtual_network_rg_name     = module.rg1.name
  virtual_network_name        = azurerm_virtual_network.vnet1.name
  subnet_name                 = azurerm_subnet.server.name
  admin_password              = "myS3cretP@ssword!"
  virtual_machine_os          = "windows" # windows, windows-sql or linux
  # enable_public_ip            = true

  depends_on = [module.rg1, azurerm_subnet.server]
}
```


Example 2

```tf
module "naming" {
  source              = "github.com/sameeraman/terraform-azurerm-naming"
  company-prefix      = "fbk"
  region-prefix       = "use1"
  environment-prefix  = "prd"
}

module "rg1" {
  source     = "github.com/sameeraman/terraform-azurerm-resource-group"

  name       = join("-", [module.naming.resource_group.name,"001"])
  location   = var.location
  tags       = var.tags
}

resource "azurerm_virtual_network" "vnet1" {
  name                = join("-", [module.naming.virtual_network.name,"001"])
  location            = var.location
  resource_group_name = module.rg1.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "server" {
  name                 = "Server"
  resource_group_name  = module.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

module "virtual-machine" {
  source = "github.com/sameeraman/terraform-azurerm-virtual-machine?ref=v1.0.0"

  virtual_machine_name        = join("", [module.naming.virtual_machine.name,"01"])
  virtual_machine_rg_name     = module.rg1.name
  location                    = var.location
  virtual_network_rg_name     = module.rg1.name
  virtual_network_name        = azurerm_virtual_network.vnet1.name
  subnet_name                 = azurerm_subnet.server.name
  admin_password              = "myS3cretP@ssword!"
  virtual_machine_os          = "windows"   # windows, windows-sql or linux
  enable_public_ip            = true        # default is false
  tags                        = var.tags

  depends_on = [module.rg1, azurerm_subnet.server]
}

```
