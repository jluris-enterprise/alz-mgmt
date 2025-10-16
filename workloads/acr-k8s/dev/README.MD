# Sequence
https://learn.microsoft.com/en-us/samples/azure-samples/avm-terraform-labs/avm-terraform-labs/

1) copy the registry module in Terraform or AVM
  * AVM - https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/
  * Terraform Registry - https://registry.terraform.io/browse/modules?provider=azure
2) Add a variable in resource_name_templates
3) 

# Errors

Error: a resource with the ID "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-kubernetes-acr-k8s-dev-uaenorth-001" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_user_assigned_identity" for more information
│
│   with module.user_assigned_managed_identity["kubernetes"].azurerm_user_assigned_identity.this,
│   on .terraform\modules\user_assigned_managed_identity\main.tf line 2, in resource "azurerm_user_assigned_identity" "this":
│    2: resource "azurerm_user_assigned_identity" "this" {
│
│ a resource with the ID
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-kubernetes-acr-k8s-dev-uaenorth-001" already
│ exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_user_assigned_identity" for more information
╵
╷
│ Error: a resource with the ID "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-kubelet-acr-k8s-dev-uaenorth-001" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_user_assigned_identity" for more information
│
│   with module.user_assigned_managed_identity["kubelet"].azurerm_user_assigned_identity.this,
│   on .terraform\modules\user_assigned_managed_identity\main.tf line 2, in resource "azurerm_user_assigned_identity" "this":
│    2: resource "azurerm_user_assigned_identity" "this" {
│
│ a resource with the ID
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-kubelet-acr-k8s-dev-uaenorth-001" already
│ exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_user_assigned_identity" for more information
╵
╷
│ Error: a resource with the ID "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-acr-k8s-dev-uaenorth-001" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_user_assigned_identity" for more information
│
│   with module.user_assigned_managed_identity["uami"].azurerm_user_assigned_identity.this,
│   on .terraform\modules\user_assigned_managed_identity\main.tf line 2, in resource "azurerm_user_assigned_identity" "this":
│    2: resource "azurerm_user_assigned_identity" "this" {
│
│ a resource with the ID
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-acr-k8s-dev-uaenorth-001" already exists - to
│ be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_user_assigned_identity" for more information
╵
╷
│ Error: Failed to create/update resource
│
│   with module.virtual_network.azapi_resource.vnet,
│   on .terraform\modules\virtual_network\main.tf line 3, in resource "azapi_resource" "vnet":
│    3: resource "azapi_resource" "vnet" {
│
│ creating/updating Resource: (ResourceId
│ "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-acr-k8s-dev-uaenorth-001/providers/Microsoft.Network/virtualNetworks/vnet-acr-k8s-dev-uaenorth-001" / Api Version "2024-07-01"): PUT
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