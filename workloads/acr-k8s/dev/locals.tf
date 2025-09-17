locals {
  name_replacements = {
    workload    = var.resource_name_workload
    environment = var.resource_name_environment
    location    = var.location
    sequence    = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = { for k, v in var.resource_name_templates : k => templatestring(v, local.name_replacements) }
}
