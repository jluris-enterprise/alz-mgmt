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


# data "azapi_resource_id" "node_user_assigned_identity" {
#   type        = "Microsoft.ManagedIdentity/userAssignedIdentities@latest"
#   resource_id = var.node_user_assigned_identity_id
# }

# data "azapi_resource_id" "kubelet_user_assigned_identity" {
#   type        = "Microsoft.ManagedIdentity/userAssignedIdentities@latest"
#   resource_id = var.kubelet_user_assigned_identity_id
# }