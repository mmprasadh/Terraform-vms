# Specify Terraform version and provider version
terraform {
  required_version = ">= 1.4.0" # Replace with the version you're using
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.70" # Use the latest compatible version
    }
  }
}

# Specify the provider
provider "azurerm" {
  features {}
  subscription_id = "5e987820-93e7-415c-873f-56fff95a12ce"
  
}

/*
# Define the resource group
resource "azurerm_resource_group" "rg" {
  # name     = "example-resource-group"
  name     = "rg-stsuai-dev-vnet"
  location = "West Europe"
}

# Define the virtual network
resource "azurerm_virtual_network" "vnet" {
  # name                = "example-vnet"
  # address_space       = ["10.0.0.0/16"]
  
  name                = "vnt-stsuai-dev-weu"
  address_space       = ["10.225.4.0/28"]
  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
*/

# Define the subnet
resource "azurerm_subnet" "subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  # address_prefixes     = ["10.0.1.0/24"]
  # Since the /28 block has 16 IPs, the same VNET address space will be used to create a single Subnet.  
  address_space       = ["10.225.4.0/28"]
}

# Define the network interface
resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  # name                = "example-vm"
  
  name                = "AZ-CMDBDEV01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ls"

  admin_username                  = "adminuser"
  admin_password                  = "P@ssword1234!" # Use a more secure password in production
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}




/*

# Specify Terraform version and provider version
terraform {
  required_version = ">= 1.4.0" # Replace with the version you're using
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.70" # Use the latest compatible version
    }
  }
}

# Specify the provider
provider "azurerm" {
  features {}
  subscription_id = "eb43c2e0-5468-4647-9aeb-edf7e60f00e2"
}

# Define the resource group
resource "azurerm_resource_group" "rg" {
  name     = "example-resource-group"
  location = "West Europe"
}

# Define the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Define the subnet
resource "azurerm_subnet" "subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define the network interface
resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ls"

  admin_username                  = "adminuser"
  admin_password                  = "P@ssword1234!" # Use a more secure password in production
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

*/
