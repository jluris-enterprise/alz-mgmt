resource "azurerm_resource_group" "identity" {
  name     = module.config.custom_replacements.identity_resource_group_name
  location = module.config.custom_replacements.starter_location_01
  tags     = module.config.tags

  provider = azurerm.identity
}
