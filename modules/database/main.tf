

/*resource "azurerm_storage_account" "example" {
  name                     = "aowijefoijawe"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}

resource "azurerm_mssql_server" "example" {
  name                         = "awefawefasd"
  resource_group_name = var.earg_name
  location            = var.earg_loc
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
  
}

resource "azurerm_mssql_database" "example" {
  name           = "example-db"
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb         = 250
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  enclave_type   = "Default"

  tags = {
    foo = "bar"
  }

}*/