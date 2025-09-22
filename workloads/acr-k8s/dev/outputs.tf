output "resource_names" {
  description = "The names of resources created in this module"
  value       = local.resource_names
}

output "uami_id" {
  description = "The principal ID of user assigned managed identities created in this module"
  value = {
    kubelet_user_assigned_managed  = module.user_assigned_managed_identity["kubelet"].resource_id
    node_user_assigned_managed     = module.user_assigned_managed_identity["kubernetes"].resource_id
    user_assigned_managed_identity = module.user_assigned_managed_identity["uami"].resource_id
  }
}

output "uami_metadata" {
  description = "Metadata of user assigned managed identities"
  value = {
    kubelet = {
      name                = data.azapi_resource_id.kubelet_user_assigned_identity.name
      resource_group_name = data.azapi_resource_id.kubelet_user_assigned_identity.resource_group_name
    }
    node = {
      name                = data.azapi_resource_id.node_user_assigned_identity.name
      resource_group_name = data.azapi_resource_id.node_user_assigned_identity.resource_group_name
    }
    uami = {
      name                = data.azapi_resource_id.user_assigned_identity.name
      resource_group_name = data.azapi_resource_id.user_assigned_identity.resource_group_name
    }
  }
}
