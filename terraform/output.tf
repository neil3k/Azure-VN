output "virtual_network_id" {
  value = azurerm_virtual_network.azure_k8s_vn.id
}

output "public_subnet_ids" {
  value = values(azurerm_subnet.public_subnet)[*].id
}

output "private_subnet_ids" {
  value = values(azurerm_subnet.private_subnet)[*].id
}

output "azure_natgw_ip" {
  value = azurerm_public_ip.ngw-ip.ip_address
}