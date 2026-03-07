module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.1"

  name                          = local.resource_names.key_vault_name
  location                      = var.location
  resource_group_name           = local.runner_resource_group.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = true

  keys = var.key_vault.keys

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.kv_zone.id]
      subnet_resource_id            = data.azurerm_subnet.subnet_management_pe.id
      subresource_name              = ["vault"]
      tags                          = var.tags
    }
  }

  wait_for_rbac_before_key_operations = {
    create = "60s"
  }

  network_acls = {
    bypass   = "AzureServices"
    ip_rules = [local.my_cidr_slash_24]
  }

  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags
}
