output "resource_names" {
  description = "The names of resources created in this module"
  value       = local.resource_names
  
}

output "uami_principal_id" {
  description = "The principal ID of user assigned managed identities created in this module"
  value       = local.uami_names
}

# output "uami_ids" {
#   description = "The IDs of user assigned managed identities created in this module"
#   value       = local.uami_names.id
# }

