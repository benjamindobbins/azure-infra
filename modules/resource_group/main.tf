resource "azurerm_resource_group" "earg" {
    name = "EastAsia"
    location = "eastasia"
    }

resource "azurerm_resource_group" "userg" {
    name = "USEast"
    location = "eastus2"
}