# Sequence
https://learn.microsoft.com/en-us/samples/azure-samples/avm-terraform-labs/avm-terraform-labs/

1) copy the registry module in Terraform or AVM
  * AVM - https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/
  * Terraform Registry - https://registry.terraform.io/browse/modules?provider=azure
2) Add a variable in resource_name_templates
3) 

# Errors

 Error: Resource not found
│
│   with data.azapi_resource.resource_group,
│   on data.tf line 19, in data "azapi_resource" "resource_group":
│   19: data "azapi_resource" "resource_group" {
│
│ resource "Resource: (ResourceId \"/subscriptions/0f360a6d-0f50-47f1-8530-48fdc5828b03/resourceGroups/rg-acr-k8s-dev-uksouth-001\" / Api Version \"2021-04-01\")" not found

 # module.aks_cluster.module.nodepools["unp1"].azurerm_kubernetes_cluster_node_pool.this[0] will be updated in-place
  ~ resource "azurerm_kubernetes_cluster_node_pool" "this" {
        id                            = "/subscriptions/0f360a6d-0f50-47f1-8530-48fdc5828b03/resourceGroups/rg-acr-k8s-dev-uksouth-001/providers/Microsoft.ContainerService/managedClusters/aks-acr-k8s-dev-uksouth-001/agentPools/userpool1"
        name                          = "userpool1"
      ~ node_taints                   = [
          - "kubernetes.azure.com/scalesetpriority=spot:NoSchedule",
        ]
        tags                          = {}
      + temporary_name_for_rotation   = "userpool1b"
      ~ vm_size                       = "Standard_B2s" -> "Standard_B2als_v2"
        # (29 unchanged attributes hidden)
    }

  # module.aks_cluster.module.nodepools["unp2"].azurerm_kubernetes_cluster_node_pool.this[0] will be updated in-place
  ~ resource "azurerm_kubernetes_cluster_node_pool" "this" {
        id                            = "/subscriptions/0f360a6d-0f50-47f1-8530-48fdc5828b03/resourceGroups/rg-acr-k8s-dev-uksouth-001/providers/Microsoft.ContainerService/managedClusters/aks-acr-k8s-dev-uksouth-001/agentPools/userpool2"
        name                          = "userpool2"
      ~ node_taints                   = [
          - "kubernetes.azure.com/scalesetpriority=spot:NoSchedule",
        ]
        tags                          = {}
      + temporary_name_for_rotation   = "userpool2b"
      ~ vm_size                       = "Standard_B2s" -> "Standard_B2als_v2"
        # (29 unchanged attributes hidden)
    }
