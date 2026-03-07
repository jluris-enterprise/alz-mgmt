module "avm-res-network-publicipaddress" {
  source   = "Azure/avm-res-network-publicipaddress/azurerm"
  version  = "0.2.1"
  for_each = var.public_ip_addresses

  name                = coalesce(try(each.value.name, null), local.resource_names.public_ip_address_name)
  resource_group_name = coalesce(try(each.value.resource_group_name, null), local.runner_resource_group.name)
  location            = coalesce(try(each.value.location, null), var.location)
  sku                 = each.value.sku
  ip_version          = coalesce(try(each.value.ip_version, null), "IPv4")
  allocation_method   = each.value.allocation_method
}