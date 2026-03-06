resource "azurerm_virtual_network" "management_runners" {
  name                = module.config.custom_replacements.management_runner_virtual_network_name
  location            = module.config.custom_replacements.starter_location_01
  resource_group_name = azurerm_resource_group.management_runners.name
  address_space       = [module.config.custom_replacements.management_runner_virtual_network_address_space]
  tags                = module.config.tags

  provider = azurerm.management
}
