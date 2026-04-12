module "virtual_machine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"

  for_each                   = var.virtual_machines
  resource_group_name        = local.runner_resource_group.name
  computer_name              = each.value.computer_name != null ? each.value.computer_name : local.resource_names.virtual_machine_computer_name
  patch_assessment_mode      = each.value.patch_assessment_mode
  os_type                    = each.value.os_type
  name                       = local.resource_names.virtual_machine_name
  sku_size                   = each.value.sku_size
  location                   = var.location
  zone                       = try(each.value.zone, null)
  priority                   = try(each.value.priority, "Regular")
  eviction_policy            = try(each.value.eviction_policy, null)
  max_bid_price              = try(each.value.max_bid_price, null)
  encryption_at_host_enabled = var.enable_encryption_at_host # Turned off by default in this demo as requires the Microsoft.Compute/EncryptionAtHost feature to be enabled on the subscription

  # SSH key configuration with Key Vault integration
  account_credentials = {
    admin_credentials = {
      username                           = "azlinuxadmin"
      generate_admin_password_or_ssh_key = true
    }
    key_vault_configuration = var.enable_key_vault ? {
      resource_id = module.key_vault["kv"].resource_id
    } : null
  }
  managed_identities = {
    system_assigned = true
  }
  os_disk                = each.value.os_disk
  source_image_reference = each.value.source_image_reference
  network_interfaces = {
    private = {
      name = local.resource_names.network_interface_name
      ip_configurations = {
        private = {
          name                          = "private"
          private_ip_subnet_resource_id = data.azurerm_subnet.subnet_management_runners.id
          public_ip_address_resource_id = var.enable_public_ipaddress ? module.avm-res-network-publicipaddress["pip_runner"].resource_id : null
        }
      }
    }
  }
  extensions = each.value.extensions

  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags
  depends_on = [
    module.key_vault,
    azapi_update_resource.enable_encryption_at_host,
  ]
}

resource "azapi_update_resource" "enable_encryption_at_host" {
  count = var.enable_encryption_at_host ? 1 : 0

  type = "Microsoft.Features/featureProviders/subscriptionFeatureRegistrations@2021-07-01"
  body = {
    properties = {}
  }
  resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Features/featureProviders/Microsoft.Compute/subscriptionFeatureRegistrations/EncryptionAtHost"
}
