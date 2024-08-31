resource "azurerm_public_ip" "bastionip" {
  name                = "bastionip"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastionhost" {
  name                = "bastionhost"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  sku            = "Standard"

  ip_configuration {
    name                 = "bastionipconfig"
    subnet_id            = var.earg_subnet_id1
    public_ip_address_id = azurerm_public_ip.bastionip.id
  }
}