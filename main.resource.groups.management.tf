resource "azurerm_resource_group" "management_runners" {
  name     = module.config.custom_replacements.management_runner_resource_group_name
  location = module.config.custom_replacements.starter_location_01
  tags     = module.config.tags

  provider = azurerm.management
}
