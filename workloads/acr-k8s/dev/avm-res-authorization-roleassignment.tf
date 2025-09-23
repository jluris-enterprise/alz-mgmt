module "role_assignment" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "0.3.0"

  role_assignments_azure_resource_manager = {
    uami_contributor = {
      principal_id         = module.user_assigned_managed_identity["kubernetes"].principal_id
      role_definition_name = "Contributor"
      scope                = module.resource_group.resource_id
    }
    uami_managed_identity_operator = {
      principal_id         = module.user_assigned_managed_identity["kubernetes"].principal_id
      role_definition_name = "Managed Identity Operator"
      scope                = module.user_assigned_managed_identity["kubelet"].principal_id
    }
    uami_arcpull = {
      principal_id         = module.user_assigned_managed_identity["kubelet"].principal_id
      role_definition_name = "AcrPull"
      scope                = module.container_registry.resource_id
    }
    # azuread_group = {
    #   principal_id         = data.azuread_group.this.object_id
    #   role_definition_name = "Azure Kubernetes Service Cluster User Role"
    #   scope                = module.aks_cluster.resource_id
    #   depends_on           = [module.aks_cluster]
    # }
  }
}
