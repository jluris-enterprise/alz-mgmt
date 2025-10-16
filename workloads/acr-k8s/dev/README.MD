# Sequence
https://learn.microsoft.com/en-us/samples/azure-samples/avm-terraform-labs/avm-terraform-labs/

1) copy the registry module in Terraform or AVM
  * AVM - https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/
  * Terraform Registry - https://registry.terraform.io/browse/modules?provider=azure
2) Add a variable in resource_name_templates
3) 

# Errors

╷Error: a resource with the ID "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-acr-k8s-dev-uaenorth-001/federatedIdentityCredentials/fic-pull_request" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_federated_identity_credential" for more information
│
│   with azurerm_federated_identity_credential.this["pull_request"],
│   on avm-res-authorization-roleassignment.tf line 34, in resource "azurerm_federated_identity_credential" "this":
│   34: resource "azurerm_federated_identity_credential" "this" {
│
│ a resource with the ID
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-acr-k8s-dev-uaenorth-001/federatedIdentityCredentials/fic-pull_request"
│ already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_federated_identity_credential" for
│ more information
╵
╷
│ Error: a resource with the ID "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-acr-k8s-dev-uaenorth-001/federatedIdentityCredentials/fic-github_actions" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_federated_identity_credential" for more information
│
│   with azurerm_federated_identity_credential.this["github_actions"],
│   on avm-res-authorization-roleassignment.tf line 34, in resource "azurerm_federated_identity_credential" "this":
│   34: resource "azurerm_federated_identity_credential" "this" {
│
│ a resource with the ID
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-acr-k8s-dev-uaenorth-001/federatedIdentityCredentials/fic-github_actions"
│ already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_federated_identity_credential" for
│ more information
╵
╷
│ Error: unexpected status 409 (409 Conflict) with error: RoleAssignmentExists: The role assignment already exists.
│
│   with module.role_assignment.azurerm_role_assignment.basic["uami_managed_identity_operator"],
│   on .terraform\modules\role_assignment\main.tf line 18, in resource "azurerm_role_assignment" "basic":
│   18: resource "azurerm_role_assignment" "basic" {
│
╵
╷
│ Error: unexpected status 409 (409 Conflict) with error: RoleAssignmentExists: The role assignment already exists.
│
│   with module.role_assignment.azurerm_role_assignment.basic["uami_contributor"],
│   on .terraform\modules\role_assignment\main.tf line 18, in resource "azurerm_role_assignment" "basic":
│   18: resource "azurerm_role_assignment" "basic" {
│
╵
╷
│ Error: Failed to create/update resource
│
│   with module.virtual_network.azapi_resource.vnet,
│   on .terraform\modules\virtual_network\main.tf line 3, in resource "azapi_resource" "vnet":
│    3: resource "azapi_resource" "vnet" {
│
│ creating/updating Resource: (ResourceId
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.Network/virtualNetworks/vnet-acr-k8s-dev-uaenorth-001" / Api Version
│ "2024-07-01"): PUT
│ https://management.azure.com/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.Network/virtualNetworks/vnet-acr-k8s-dev-uaenorth-001
│ --------------------------------------------------------------------------------
│ RESPONSE 404: 404 Not Found
│ ERROR CODE: NotFound
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "NotFound",
│     "message": "Resource /subscriptions/2bb0667b-d883-4406-b19a-a3083ba05bd8/resourceGroups/rg-hub-ddos-uaenorth/providers/Microsoft.Network/ddosProtectionPlans/ddos-uaenorth not found.",
│     "details": []
│   }
│ }
│ --------------------------------------------------------------------------------