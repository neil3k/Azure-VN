# Microsoft Azure Virtual Network Module

## Purpose
This module provides support for the creation of a Virtual Network, Private and Public subnets, Route Tables and a NAT Gateway.

## Description
The Azure Virtual Network module is for use creating a stand alone Virtual Network within Microsoft Azure

## Usage Instructions
Built for use alongside other modules.

```commandline
locals {
    common_tags = {
        ManagedBy = "terraform"
       }
}

module "vpc {
    source                      = ".../modules/azure-vn
    location                    = "West Europe
    name                        = "cluster"
    vn_cidr_block               = ["10.0.0.0/16"]
    private_subnets_prefix_list = subnet1 = {address_prefix = ["10.0.3.0/24"] name = "public-subnet-1"}
    public_subnets_prefix_list  = subnet1 = {address_prefix = ["10.0.3.0/24"] name = "private-subnet-1"}
}
```

## Preconditions and Assumptions

None

## Requirements

No Requirements

## Providers


| Name    | Version |
|---------|---------|
| azurerm | 3.81.0  |

## Resources

| Name                                              | Type     |
|---------------------------------------------------|----------|
| azurerm_resource_group                            | resource |
| azurerm_virtual_network                           | resource |
| azurerm_subnet                                    | resource |
| azurerm_public_ip                                 | resource |
| azurerm_route_table                               | resource |
| azurerm_subnet_route_table_association            | resource |
| azurerm_nat_gateway                               | resource |
| azurerm_nat_gateway_public_ip_association         | resource |
| azurerm_subnet_nat_gateway_association            | resource |
| azurerm_network_security_group                    | resource |
| azurerm_subnet_network_security_group_association | resource |


## Inputs

| Name                        | Description | Type         | Default | Required |
|-----------------------------|-------------|--------------|---------|----------|
| location                    | n/a         | string       | n/a     | yes      |
| name                        | n/a         | string       | n/a     | yes      |
| vn_cidr_block               | n/a         | list(string) | n/a     | yes      |
| private_subnets_prefix_list | n/a         | map(object)  | n/a     | yes      |
| public_subnets_prefix_list  | n/a         | map(object)  | n/a     | yes      |
| common_tags                 | n/a         | map(string)  | n/a     | yes      |

## Outputs

| Name               | Description |
|--------------------|-------------|
| virtual_network_id | n/a         |
| public_subnet_ids  | n/a         |
| private_subnet_ids | n/a         |
| azure_natgw_ip     | n/a         |

## Example tfvars file

```commandline
location = "West Europe"
vn_cidr_block =  ["10.0.0.0/16"]
name = "Test"
common_tags = {
    "Managed By" = "terraform"
  }

private_subnets_prefix_list = {
  subnet1 = {
    address_prefix = ["10.0.3.0/24"]
    name           = "private-subnet-1"
  },
  subnet2 = {
    address_prefix = ["10.0.4.0/24"]
    name           = "private-subnet-2"
  }
}

public_subnets_prefix_list = {
    subnet1 = {
      address_prefix = ["10.0.1.0/24"]
      name           = "public-subnet-1"
    },
    subnet2 = {
      address_prefix = ["10.0.2.0/24"]
      name           = "public-subnet-2"
    }
}
```