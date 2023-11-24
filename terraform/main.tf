resource "azurerm_resource_group" "az-resource-group" {
  name     = "${var.name}-az-resource-group"
  location = var.location

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-virtual-netowrk"
    }
  )
}

resource "azurerm_virtual_network" "azure_k8s_vn" {
  name                    = "${var.name}-virtual-network"
  resource_group_name     = azurerm_resource_group.az-resource-group.name
  location                = azurerm_resource_group.az-resource-group.location
  address_space           = var.vn_cidr_block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-virtual-network"
    },
  )
}

resource "azurerm_subnet" "public_subnet" {
  for_each             = var.public_subnets_prefix_list
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.az-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure_k8s_vn.name
  address_prefixes     = each.value.address_prefix
}

resource "azurerm_subnet" "private_subnet" {
  for_each             = var.private_subnets_prefix_list
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.az-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure_k8s_vn.name
  address_prefixes     = each.value.address_prefix
}

# NAT Gateway
resource "azurerm_public_ip" "ngw-ip" {
  name                = "${var.name}-ngw-1"
  resource_group_name = azurerm_resource_group.az-resource-group.name
  location            = azurerm_resource_group.az-resource-group.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_route_table" "public-route-table" {
  name                = "${var.name}-public-rt"
  resource_group_name = azurerm_resource_group.az-resource-group.name
  location            = azurerm_resource_group.az-resource-group.location
}

resource "azurerm_subnet_route_table_association" "public" {
  for_each       = azurerm_subnet.public_subnet
  route_table_id = azurerm_route_table.public-route-table.id
  subnet_id      = each.value.id
}

resource "azurerm_route_table" "private-route-table" {
  name                = "${var.name}-private-rt"
  resource_group_name = azurerm_resource_group.az-resource-group.name
  location            = azurerm_resource_group.az-resource-group.location
}

resource "azurerm_subnet_route_table_association" "private" {
  for_each       = azurerm_subnet.private_subnet
  route_table_id = azurerm_route_table.private-route-table.id
  subnet_id      = each.value.id
}

resource "azurerm_nat_gateway" "ngw-1" {
  name                = "${var.name}-nat-gateway-1"
  resource_group_name = azurerm_resource_group.az-resource-group.name
  location            = azurerm_resource_group.az-resource-group.location
  sku_name            = "Standard"

    tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-virtual-netowrk"
    }
  )
}

resource "azurerm_nat_gateway_public_ip_association" "nat-gw-assoc-1" {
  nat_gateway_id       = azurerm_nat_gateway.ngw-1.id
  public_ip_address_id = azurerm_public_ip.ngw-ip.id
}

resource "azurerm_subnet_nat_gateway_association" "ngw" {
  for_each       = azurerm_subnet.public_subnet
  subnet_id      = each.value.id
  nat_gateway_id = azurerm_nat_gateway.ngw-1.id
}

resource "azurerm_network_security_group" "DenyAllInbound" {
  name                = "${var.name}-network-security-group"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-network-security-group"
    }
  )
}

resource "azurerm_subnet_network_security_group_association" "nsg-subnet-attach" {
  for_each                  = azurerm_subnet.private_subnet
  network_security_group_id = azurerm_network_security_group.DenyAllInbound.id
  subnet_id                 = each.value.id
}