data "azurerm_resources" "connectivity_private_dns_zones" {
  resource_group_name = module.config.custom_replacements.dns_resource_group_name
  type                = "Microsoft.Network/privateDnsZones"

  # Ensure zones from the connectivity module are discoverable in the same apply.
  depends_on = [module.hub_and_spoke_vnet]

  provider = azurerm.connectivity
}

locals {
  connectivity_private_dns_zones = {
    for zone in data.azurerm_resources.connectivity_private_dns_zones.resources :
    zone.name => zone
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "management_runners" {
  for_each = local.connectivity_private_dns_zones

  name                  = "lnk-${azurerm_virtual_network.management_runners.name}"
  resource_group_name   = module.config.custom_replacements.dns_resource_group_name
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.management_runners.id
  registration_enabled  = false

  provider = azurerm.connectivity
}
