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
      scope                = module.user_assigned_managed_identity["kubelet"].resource_id
    }
    uami_acrpull = {
      principal_id         = module.user_assigned_managed_identity["kubelet"].principal_id
      role_definition_name = "AcrPull"
      scope                = module.container_registry.resource_id
    }
    uami_acrpush = {
      principal_id         = module.user_assigned_managed_identity["uami"].principal_id
      role_definition_name = "AcrPush"
      scope                = module.container_registry.resource_id
    }
    uami_acrdelete = {
      principal_id         = module.user_assigned_managed_identity["uami"].principal_id
      role_definition_name = "AcrDelete"
      scope                = module.container_registry.resource_id
    }
  }
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = local.fic_subjects

  name                = "fic-${each.key}"
  resource_group_name = module.resource_group.name
  parent_id           = module.user_assigned_managed_identity["uami"].resource.id

  issuer   = each.value.issuer
  subject  = each.value.subject
  audience = [each.value.audience]
}
