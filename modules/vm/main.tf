resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "vm-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    load_balancer_backend_address_pool_ids = var.lb_backend_pool_ids
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = 2
  name                = "MyWinVM-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [element(azurerm_network_interface.nic[*].id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

output "private_ips" {
  value = azurerm_network_interface.nic[*].private_ip_address
}