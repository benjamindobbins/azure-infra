# Public IP for East US Load Balancer
resource "azurerm_public_ip" "eastus_public_ip" {
  name                = "eastus-lb-public-ip"
  location            = "East US"
  resource_group_name = var.userg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer for East US
resource "azurerm_lb" "eastus_lb" {
  name                = "eastus-lb"
  location            = "East US"
  resource_group_name = var.userg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-lb-ip"
    public_ip_address_id = azurerm_public_ip.eastus_public_ip.id
  }
}

# Backend Pool and Rules for East US
resource "azurerm_lb_backend_address_pool" "eastus_backend_pool" {
  name                = "eastus-backend-pool"
  loadbalancer_id     = azurerm_lb.eastus_lb.id
}

resource "azurerm_lb_probe" "eastus_probe" {
  name                = "eastus-http-probe"
  loadbalancer_id     = azurerm_lb.eastus_lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "eastus_rule" {
  name                           = "eastus-http-rule"
  loadbalancer_id                = azurerm_lb.eastus_lb.id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "public-lb-ip"
  frontend_port                  = 80
  backend_port                   = 80
  probe_id                       = azurerm_lb_probe.eastus_probe.id
}
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
    name           = "subnet1"
    address_prefixes = ["10.0.2.0/24"]
    security_group = azurerm_network_security_group.nsg0.id
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
