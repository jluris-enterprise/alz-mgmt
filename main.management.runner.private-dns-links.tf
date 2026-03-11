locals {
  # Keep for_each keys plan-time known by deriving them from input config, not discovered resources.
  connectivity_private_dns_private_link_zone_names = {
    for _, zone in try(local.hub_and_spoke_vnet_virtual_networks.primary.private_dns_zones.dns_zones.private_link_private_dns_zones, {}) :
    zone.zone_name => zone
  }

  connectivity_private_dns_auto_registration_zone_name = (
    try(local.hub_and_spoke_vnet_virtual_networks.primary.private_dns_zones.auto_registration_zone_enabled, false)
    && try(local.hub_and_spoke_vnet_virtual_networks.primary.private_dns_zones.auto_registration_zone_name, "") != ""
  ) ? {
    (local.hub_and_spoke_vnet_virtual_networks.primary.private_dns_zones.auto_registration_zone_name) = {
      zone_name = local.hub_and_spoke_vnet_virtual_networks.primary.private_dns_zones.auto_registration_zone_name
    }
  } : {}

  connectivity_private_dns_zone_names = merge(
    local.connectivity_private_dns_private_link_zone_names,
    local.connectivity_private_dns_auto_registration_zone_name
  )
}

resource "azurerm_private_dns_zone_virtual_network_link" "management_runners" {
  for_each = local.connectivity_private_dns_zone_names

  name                  = "lnk-${azurerm_virtual_network.management_runners.name}"
  resource_group_name   = module.config.custom_replacements.dns_resource_group_name
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.management_runners.id
  registration_enabled  = false

  depends_on = [module.hub_and_spoke_vnet]

  provider = azurerm.connectivity
}
