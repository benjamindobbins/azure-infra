
locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/Nl70QNI50IMumNHsZNqkkBDId5Q0UnCoQh/GbFJG7q8l39ApnGH1Pgc4LMQ9IeZPgBVaMtTgovyewHZN4LQnIkgW2c0xhE7C+n5gDYmN0s6K9RvUd3dRYeZE5qs4DLbkix6S0eIVTC1luvKIajfKkVKfV7YFOdlbft+mbm+zVBhPsAdz8Z0X76CbiNE2Scj1eZeuy8N6/8faAe4c6B3uH/iF/z/KJOii0wdMlkzgfNjg5Y3X4umnN9ybETpVWyev2j+H2CANvq49PnWJejlnJq1BbgmDuYZxJHW9raK5O/wcQw20inas3+3D3fIcz0DpSfycycSWZWhaWdgyt/Ld"
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


/*resource "azurerm_linux_virtual_machine_scale_set" "use_vmss" {
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
}*/