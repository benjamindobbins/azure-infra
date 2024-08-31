output "earg_subnet_id" {
  value = element(azurerm_virtual_network.eaVNet.subnet[*].id, 0)
}

output "userg_subnet_id" {
  value = element(azurerm_virtual_network.useVNet.subnet[*].id, 0)
}

output "earg_subnet_id1" {
  value = element(azurerm_virtual_network.eaVNet.subnet[*].id, 1)
}

output "userg_subnet_id1" {
  value = element(azurerm_virtual_network.useVNet.subnet[*].id, 1)
}