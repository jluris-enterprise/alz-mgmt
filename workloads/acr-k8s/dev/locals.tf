# This is a local map that defines the actual values to substitute into the templates:
locals {
  name_replacements = {
    workload    = var.resource_name_workload
    environment = var.resource_name_environment
    location    = var.location
    sequence    = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = { for k, v in var.resource_name_templates : k => templatestring(v, local.name_replacements) }
  uami_names     = { for k, v in var.user_assigned_managed_identities : k => templatestring(v.name, local.name_replacements) }
}