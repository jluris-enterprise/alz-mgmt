resource "azurerm_virtual_network" "management_runners" {
  name                = module.config.custom_replacements.management_runner_virtual_network_name
  location            = module.config.custom_replacements.starter_location_01
  resource_group_name = azurerm_resource_group.management_runners.name
  address_space       = [module.config.custom_replacements.management_runner_virtual_network_address_space]
  tags                = module.config.tags

  provider = azurerm.management
}

resource "azurerm_subnet" "management_runners" {
  name                 = "snet-platform-runners"
  resource_group_name  = azurerm_resource_group.management_runners.name
  virtual_network_name = azurerm_virtual_network.management_runners.name
  address_prefixes     = [module.config.custom_replacements.management_runner_subnet_address_prefix]

  provider = azurerm.management
}

data "azurerm_virtual_network" "connectivity_hub_primary" {
  name                = module.config.custom_replacements.primary_virtual_network_name
  resource_group_name = module.config.custom_replacements.connectivity_hub_primary_resource_group_name

  provider = azurerm.connectivity
}

resource "azurerm_virtual_network_peering" "management_runners_to_hub" {
  name                         = "peer-runners-to-hub"
  resource_group_name          = azurerm_resource_group.management_runners.name
  virtual_network_name         = azurerm_virtual_network.management_runners.name
  remote_virtual_network_id    = data.azurerm_virtual_network.connectivity_hub_primary.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = module.config.custom_replacements.management_runner_peering_use_remote_gateways

  provider = azurerm.management
}

resource "azurerm_virtual_network_peering" "hub_to_management_runners" {
  name                         = "peer-hub-to-runners"
  resource_group_name          = module.config.custom_replacements.connectivity_hub_primary_resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.connectivity_hub_primary.name
  remote_virtual_network_id    = azurerm_virtual_network.management_runners.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = module.config.custom_replacements.management_runner_peering_allow_gateway_transit

  provider = azurerm.connectivity
}
