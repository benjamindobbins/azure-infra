
locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN you@me.com"
}

resource "azurerm_linux_virtual_machine_scale_set" "ea_vmss" {
  name                = "ea-vmss"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "ben"

  admin_ssh_key {
    username   = "ben"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.earg_subnet_id
    }
  }
      provisioner "local-exec" {
        command = "az vmss deallocate --resource-group ${var.earg_name} --name ${self.name}"
        }
  
  }
  resource "azurerm_public_ip" "example" {
  name                = "nat-gateway-pip"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_nat_gateway" "eaNatGateway" {
  name                = "eaNatGateway"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "eaNatGateway" {
  nat_gateway_id       = azurerm_nat_gateway.eaNatGateway.id
  public_ip_address_id = azurerm_public_ip.example.id
}
resource "azurerm_subnet_nat_gateway_association" "eaNatGateway" {
  subnet_id     = var.earg_subnet_id
  nat_gateway_id = azurerm_nat_gateway.eaNatGateway.id
}


resource "azurerm_linux_virtual_machine_scale_set" "use_vmss" {
  name                = "use-vmss"
  resource_group_name = var.userg_name
  location            = var.userg_loc
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "ben"

  admin_ssh_key {
    username   = "ben"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "usenic"
    primary = true

    ip_configuration {
      name      = "useip"
      primary   = true
      subnet_id = var.userg_subnet_id  # subnet1 ea

    }
  }
      provisioner "local-exec" {
        command = "az vmss deallocate --resource-group ${var.userg_name} --name ${self.name}"
        }
}