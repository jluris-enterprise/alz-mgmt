#  Import the existing MG into the exact resource address TF is trying to create
# import {
#   to = module.aks_cluster.module.nodepools["unp2"].azurerm_kubernetes_cluster_node_pool.this[0]
#   id = "/subscriptions/0f360a6d-0f50-47f1-8530-48fdc5828b03/resourceGroups/rg-acr-k8s-dev-uksouth-001/providers/Microsoft.ContainerService/managedClusters/aks-acr-k8s-dev-uksouth-001/agentPools/userpool2"
# }

# import {
#   to = module.aks_cluster.module.nodepools["unp1"].azurerm_kubernetes_cluster_node_pool.this[0]
#   id = "/subscriptions/0f360a6d-0f50-47f1-8530-48fdc5828b03/resourceGroups/rg-acr-k8s-dev-uksouth-001/providers/Microsoft.ContainerService/managedClusters/aks-acr-k8s-dev-uksouth-001/agentPools/userpool1"
# }