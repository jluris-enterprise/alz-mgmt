data "azurerm_client_config" "current" {}
# data "azuread_client_config" "current" {}

data "terraform_remote_state" "alz_platform" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-alz-mgmt-state-uaenorth-001"
    storage_account_name = "stoalzmgmuae001wksi"
    container_name       = "mgmt-tfstate"
    key                  = "terraform.tfstate"
    subscription_id      = "42dedbdb-3ad0-438c-a796-66bb1c08686a"
    tenant_id            = "7d1a04ec-981a-405a-951b-dd2733120e4c"
    use_azuread_auth     = true
  }
}

# Optional: keep data lookups to validate remote-state values exist in Azure.
data "azurerm_resource_group" "runners" {
  name     = local.runner_resource_group_name
  provider = azurerm.management
}

data "azurerm_virtual_network" "vnet_management_runners" {
  name                = local.management_runner_virtual_network_name
  resource_group_name = local.runner_resource_group_name
  provider            = azurerm.management
}

data "azurerm_subnet" "subnet_management_runners" {
  name                 = local.management_runner_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_management_runners.name
  resource_group_name  = local.runner_resource_group_name
  provider             = azurerm.management
}

data "azurerm_subnet" "subnet_management_pe" {
  name                 = local.management_private_endpoints_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_management_runners.name
  resource_group_name  = local.runner_resource_group_name
  provider             = azurerm.management
}

data "azurerm_private_dns_zone" "kv_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.dns_resource_group_name
  provider            = azurerm.connectivity
}

data "azurerm_private_dns_zone" "sta_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.dns_resource_group_name
  provider            = azurerm.connectivity
}

data "azurerm_storage_account" "management_tfstate" {
  name                = local.platform_state_storage_account_name
  resource_group_name = local.platform_state_resource_group_name
  provider            = azurerm.management
}

data "azurerm_log_analytics_workspace" "management" {
  name                = local.log_analytics_workspace_name
  resource_group_name = local.management_resource_group_name
  provider            = azurerm.management
}

data "azuread_service_principal" "sp_root" {
  display_name = "sp-alz-root"
}

data "azuread_user" "this" {
  object_id = "88c915ea-4e72-4ea9-8a82-f986cf901207"
}


data "http" "ip" {
  url = "https://api.ipify.org/"
  retry {
    attempts     = 5
    max_delay_ms = 1000
    min_delay_ms = 500
  }
}
