variable "location" {
  type        = string
  description = "Resource Location"
}

variable "vn_cidr_block" {
  type        = list(string)
  description = "Address Space for the Virtual Network"
}

variable "name" {
  type        = string
  description = "Name for resources"
}

variable "common_tags" {
  type = map(string)
}

variable "private_subnets_prefix_list" {
  type = map(object({
    address_prefix = list(string)
    name           = string
  }))
}

variable "public_subnets_prefix_list" {
  type = map(object({
    address_prefix = list(string)
    name           = string
  }))
}