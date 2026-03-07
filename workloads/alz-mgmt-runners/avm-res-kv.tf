module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.1"

  name                          = local.resource_names.key_vault_name
  location                      = var.location
  resource_group_name           = local.runner_resource_group.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = false

  keys = var.key_vault.keys

  private_endpoints = {
    primary = {
      name                          = local.resource_names.key_vault_private_endpoint_name
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.kv_zone.id]
      subnet_resource_id            = data.azurerm_subnet.subnet_management_pe.id
      subresource_name              = ["vault"]
      tags                          = var.tags
    }
  }

  role_assignments = {
    current_principal_key_vault_secrets_officer = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_type             = "ServicePrincipal"
      principal_id               = data.azurerm_client_config.current.object_id # This is the AZURE_CLIENT_ID from the provider block's authentication
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
