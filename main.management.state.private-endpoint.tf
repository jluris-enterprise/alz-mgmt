# Private endpoint (blob) for the platform Terraform state storage account.
# The storage account itself is created by the bootstrap, not by this stack.
# The privatelink.blob.core.windows.net zone comes from the hub DNS config in
# platform-landing-zone.auto.tfvars and is linked to the runner VNet in
# main.management.runner.private-dns-links.tf.

locals {
  platform_state_storage_account_name = "stoalzmgmuae001wksi"
  platform_state_resource_group_name  = "rg-alz-mgmt-state-uaenorth-001"

  # Built rather than looked up: the zone is created in this same apply.
  private_dns_zone_blob_id = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net",
    try(var.subscription_ids["connectivity"], var.subscription_id_connectivity),
    module.config.custom_replacements.dns_resource_group_name
  )
}

data "azurerm_storage_account" "platform_state" {
  name                = local.platform_state_storage_account_name
  resource_group_name = local.platform_state_resource_group_name

  provider = azurerm.management
}

resource "azurerm_private_endpoint" "platform_state_blob" {
  name                = "pep-${local.platform_state_storage_account_name}-blob"
  location            = module.config.custom_replacements.starter_location_01
  resource_group_name = azurerm_resource_group.management_runners.name
  subnet_id           = azurerm_subnet.management_private_endpoints.id
  tags                = module.config.tags

  private_service_connection {
    name                           = "psc-${local.platform_state_storage_account_name}-blob"
    private_connection_resource_id = data.azurerm_storage_account.platform_state.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [local.private_dns_zone_blob_id]
  }

  # Ensure the blob zone (hub module) and its runner VNet link exist first.
  depends_on = [
    module.hub_and_spoke_vnet,
    azurerm_private_dns_zone_virtual_network_link.management_runners,
  ]

  provider = azurerm.management
}
