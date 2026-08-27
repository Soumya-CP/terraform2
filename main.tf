locals {
  common_tags = {
    environment = "development"
    managed_by  = "terraform"
    project     = "artizens"
  }
}

resource "azurerm_resource_group" "artizens" {
  name     = "artizens"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "artizens" {
  name                = "artizens-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "artizens" {
  name                 = "artizens-subnet"
  resource_group_name  = azurerm_resource_group.artizens.name
  virtual_network_name = azurerm_virtual_network.artizens.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "artizens" {
  name                = "artizens-public-ip"
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_security_group" "artizens" {
  name                = "artizens-nsg"
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name
  tags                = local.common_tags

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "artizens" {
  name                = "artizens-nic"
  location            = azurerm_resource_group.artizens.location
  resource_group_name = azurerm_resource_group.artizens.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.artizens.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.artizens.id
  }
}

resource "azurerm_network_interface_security_group_association" "artizens" {
  network_interface_id      = azurerm_network_interface.artizens.id
  network_security_group_id = azurerm_network_security_group.artizens.id
}

resource "tls_private_key" "artizens" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key" {
  content         = tls_private_key.artizens.private_key_openssh
  filename        = "${path.module}/artizens-vm.pem"
  file_permission = "0600"
}

resource "azurerm_linux_virtual_machine" "artizens" {
  name                = "artizens-vm"
  resource_group_name = azurerm_resource_group.artizens.name
  location            = azurerm_resource_group.artizens.location
  size                = "Standard_B2ats_v2"
  admin_username      = var.admin_username
  tags                = local.common_tags

  network_interface_ids = [
    azurerm_network_interface.artizens.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.artizens.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
