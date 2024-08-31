# Public IP for East US Load Balancer

resource "azurerm_network_security_group" "nsg0" {
  name                = "eaNSG"
  location            = var.earg_loc
  resource_group_name = var.earg_name
}
resource "azurerm_network_security_group" "nsg1" {
  name                = "useNSG"
  location            = var.userg_loc
  resource_group_name = var.userg_name
  
}



resource "azurerm_virtual_network" "eaVNet" {
  name                = "eaVNet"
  location            = var.earg_loc
  resource_group_name = var.earg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  

  subnet {
    name           = "subnet0"
    address_prefixes = ["10.0.1.0/24"]
    security_group = azurerm_network_security_group.nsg0.id

    }
  

  subnet {
    name           = "AzureBastionSubnet"
    address_prefixes = ["10.0.2.0/27"]
      }
  

  tags = {
    environment = "East Asia"
  }
  
}
resource "azurerm_virtual_network" "useVNet" {
  name                = "useVNet"
  location            = var.userg_loc
  resource_group_name = var.userg_name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = ["10.1.0.4", "10.1.0.5"]

  subnet {
    name           = "subnet0"
    address_prefixes = ["10.1.1.0/24"]
    security_group = azurerm_network_security_group.nsg1.id

    }
  

  subnet {
    name           = "subnet1"
    address_prefixes = ["10.1.2.0/24"]
    security_group = azurerm_network_security_group.nsg1.id
  }
  

  tags = {
    environment = "US East"
  }
}
