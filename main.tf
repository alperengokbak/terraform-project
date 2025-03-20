resource "azurerm_resource_group" "terraform_project" {
  name     = "terraform-project-resources"
  location = var.location
}

resource "azurerm_virtual_network" "terraform_vnet" {
  name                = "terraform-vnet"
  resource_group_name = azurerm_resource_group.terraform_project.name
  location            = azurerm_resource_group.terraform_project.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.terraform_project.name
  virtual_network_name = azurerm_virtual_network.terraform_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "terraform-vm-public-ip"
  resource_group_name = azurerm_resource_group.terraform_project.name
  location            = azurerm_resource_group.terraform_project.location
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "ssh_nsg" {
  name                = "ssh-nsg"
  resource_group_name = azurerm_resource_group.terraform_project.name
  location            = azurerm_resource_group.terraform_project.location

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "terraform_nic" {
  name                = "terraform-nic"
  resource_group_name = azurerm_resource_group.terraform_project.name
  location            = azurerm_resource_group.terraform_project.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "ssh_nsg_association" {
  network_interface_id      = azurerm_network_interface.terraform_nic.id
  network_security_group_id = azurerm_network_security_group.ssh_nsg.id
}

resource "azurerm_linux_virtual_machine" "terraform_vm" {
  name                = "terraform-vm"
  resource_group_name = azurerm_resource_group.terraform_project.name
  location            = azurerm_resource_group.terraform_project.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.terraform_nic.id]

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

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key)
  }
}