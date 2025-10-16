module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.15.0"

  # resource_group_name = module.resource_group.name
  resource_group_id   = module.resource_group.id
  subnets             = local.subnets
  address_space       = [var.address_space]
  location            = var.location
  name                = local.resource_names.virtual_network_name
  tags                = var.tags

  ddos_protection_plan = {
    enabled = false
  }
}
