data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://api.ipify.org/"
  retry {
    attempts     = 5
    max_delay_ms = 1000
    min_delay_ms = 500
  }
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.5.0"
}

# data "azuread_group" "this" {
#   display_name = "SG-Container_Administrator"
#   object_id = "1c1de890-2a46-4597-8f88-0e26161cf9a2"
#   security_enabled = true
# }

##################################################################### AZAPI Resources ###############################################################################

data "azapi_resource" "resource_group" {
  type = "Microsoft.Resources/resourceGroups@2021-04-01"
  # resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_names.resource_group_name}"
  resource_id = module.resource_group.resource_id
  depends_on  = [module.resource_group]
}

data "azapi_resource_id" "user_assigned_identity" {
  type        = "Microsoft.ManagedIdentity/userAssignedIdentities@latest"
  resource_id = module.user_assigned_managed_identity["uami"].resource_id
}

data "azapi_resource_id" "node_user_assigned_identity" {
  type        = "Microsoft.ManagedIdentity/userAssignedIdentities@latest"
  resource_id = module.user_assigned_managed_identity["kubernetes"].resource_id
}

data "azapi_resource_id" "kubelet_user_assigned_identity" {
  type        = "Microsoft.ManagedIdentity/userAssignedIdentities@latest"
  resource_id = module.user_assigned_managed_identity["kubelet"].resource_id
}

# To get the client_id and principal_id of a User Assigned Managed Identity use data source
data "azurerm_user_assigned_identity" "kubelet" {
  name                = data.azapi_resource_id.kubelet_user_assigned_identity.name
  resource_group_name = data.azapi_resource_id.kubelet_user_assigned_identity.resource_group_name
}

# To get the client_id and principal_id of a User Assigned Managed Identity use data source
data "azurerm_user_assigned_identity" "this" {
  name                = data.azapi_resource_id.node_user_assigned_identity.name
  resource_group_name = data.azapi_resource_id.node_user_assigned_identity.resource_group_name
}
