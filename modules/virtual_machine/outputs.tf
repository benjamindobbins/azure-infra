output "nat_gateway_public_ip" {
  value = azurerm_public_ip.example.id
  description = "The ID of the NAT Gateway Public IP"
}