output "virtual_network_id" {
  value = azurerm_virtual_network.this.id
}

output "public_subnet_ids" {
  value = values(azurerm_subnet.public_subnet)[*].id
}

output "private_subnet_ids" {
  value = values(azurerm_subnet.private_subnet)[*].id
}

output "azure_natgw_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}