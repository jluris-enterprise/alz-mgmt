locals {
  name_replacements = {
    workload = var.resource_name_workload
  }

  resource_names {for k, v in var.resource_name_templates : k => templatestring(value, local.name_replacements)}
}
