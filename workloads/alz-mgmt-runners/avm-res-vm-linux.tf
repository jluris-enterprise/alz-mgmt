module "virtual_machine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"

  for_each                   = var.virtual_machines
  resource_group_name        = module.resource_group.name
  os_type                    = each.value.os_type
  name                       = local.resource_names.virtual_machine_name
  sku_size                   = each.value.sku_size
  location                   = var.location
  zone                       = each.value.zone
  priority                   = each.value.priority        # Default is "Regular", set to "Spot" for Azure Spot VM, refer to https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure/PSRule.Rules.Azure.Compute.VirtualMachine/ for more details on supported values and configurations when using Spot VMs
  eviction_policy            = each.value.eviction_policy # Required when priority is set to "Spot",
  max_bid_price              = each.value.max_bid_price
  encryption_at_host_enabled = var.enable_encryption_at_host # Turned off by default in this demo as requires the Microsoft.Compute/EncryptionAtHost feature to be enabled on the subscription

  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = module.key_vault.resource_id
  }
  managed_identities = {
    system_assigned = true
  }
  os_disk = each.value.os_disk
  source_image_reference = each.value.source_image_reference
  network_interfaces = each.value.network_interfaces

  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags

  depends_on = [module.key_vault, azapi_update_resource.enable_encryption_at_host]
}

resource "azapi_update_resource" "enable_encryption_at_host" {
  count = var.enable_encryption_at_host ? 1 : 0

  type = "Microsoft.Features/featureProviders/subscriptionFeatureRegistrations@2021-07-01"
  body = {
    properties = {}
  }
  resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Features/featureProviders/Microsoft.Compute/subscriptionFeatureRegistrations/EncryptionAtHost"
}
