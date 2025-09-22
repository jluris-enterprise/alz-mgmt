module "avm-res-authorization-roleassignment" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "0.3.0"

  role_assignments_azure_resource_manager = {
    uami_contributor = {
      principal_id         = module.avm-res-managedidentity-userassignedidentity["uami"].principal_id
      role_definition_name = "Contributor"
      scope                = module.avm-res-resources-resourcegroup.resource_id
    }
    uami_kubelet = {
      principal_id         = module.avm-res-managedidentity-userassignedidentity["kubelet"].principal_id
      role_definition_name = "Reader"
      scope                = module.avm-res-resources-resourcegroup.resource_id
    }
  }
}
