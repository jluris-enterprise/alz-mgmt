locals {
  runner_resource_group_name = data.terraform_remote_state.alz_platform.outputs.management_runner_resource_group_name
}

locals {
  runner_resource_group = {
    name = data.azurerm_resource_group.runners.name
    id   = data.azurerm_resource_group.runners.id
  }
}

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
      workspace_resource_id = data.azurerm_log_analytics_workspace.management.id
    }
  }
}

locals {
  my_ip_address_split = split(".", data.http.ip.response_body)
}