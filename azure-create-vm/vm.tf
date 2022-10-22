resource "azurerm_linux_virtual_machine" "vm-1" {
  name                = "${var.project_unique_id}-vm-1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.ni-vm-1.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
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

resource "azurerm_network_interface" "ni-vm-1" {
  name                = "vm-1-ni"
  location            = var.azure_default_location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "vm-1-ip"
    subnet_id                     = azurerm_subnet.vms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip-vm-1.id
  }
}

resource "azurerm_public_ip" "pubip-vm-1" {
  name                = "${var.project_unique_id}-pubip-vm-1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}