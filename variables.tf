variable "virtual_machine_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "virtual_machine_rg_name" {
  description = "Name of the virtual machine resource group"
  type        = string
}

variable "location" {
  description = "Azure region to provision the virtual machine"
  type        = string
}

variable "virtual_network_rg_name" {
  description = "Name of the virtual network resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the VNET that the VM to be provisioned"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet that the VM to be provisioned"
  type        = string
}

variable "virtual_machine_size" {
  description = "Size of the virtual machine eg: Standard_B2ms"
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "administrator username for the server"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "administrator password for the server"
  type        = string
}

variable "virtual_machine_os" {
  type        = string
  default     = "linux"
  description = "virtual machine operating system (windows or linux)"
  validation {
    condition     = can(regex("linux|windows|windows-sql", var.virtual_machine_os))
    error_message = "ERROR: Operating System must be 'windows', 'windows-sql' OR 'linux'."
  }
}

variable "virtual_machine_disk_type" {
  type        = string
  default     = "Premium_LRS"
  description = "virtual machine disk type (Premium or Standard)"
  validation {
    condition     = can(regex("Standard_LRS|StandardSSD_LSR|Premium_LRS", var.virtual_machine_disk_type))
    error_message = "ERROR: OS Disk Type must be 'Standard_LRS', 'StandardSSD_LSR' OR 'Premium_LRS'."
  }
}

variable "virtual_machine_disk_size" {
  type        = number
  default     = 25
  description = "virtual machine disk size in GB (default is 25GB)"
}

variable "enable_public_ip" {
  type        = bool
  default     = false
  description = "Create Public IP for the Virtual Machine"
}

variable "tags" {
  description = "Tags for categorization"
  type        = map(any)
  default     = {}
}