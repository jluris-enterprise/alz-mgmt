locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    sequence       = format("%03d", var.resource_name_sequence_start)
    uniqueness     = random_string.unique_name.id
    location_short = var.resource_name_location_short == "" ? module.avm-utl-regions.regions_by_name[var.location].geo_code : var.resource_name_location_short
  }
  resource_names = { for k, v in var.resource_name_templates : k => templatestring(v, local.name_replacements) }
}

locals {
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                  = "custom"
      workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
    }
  }
}

