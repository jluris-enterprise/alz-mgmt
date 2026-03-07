locals {
  platform_outputs = data.terraform_remote_state.alz_platform.outputs
  platform_replacements = try(local.platform_outputs.templated_inputs.custom_replacements, {})

  management_runner_resource_group_name    = try(local.platform_outputs.management_runner_resource_group_name, lookup(local.platform_replacements, "management_runner_resource_group_name", format("rg-mgmt-platform-%s", var.location)))
  management_runner_virtual_network_name   = try(local.platform_outputs.management_runner_virtual_network_name, lookup(local.platform_replacements, "management_runner_virtual_network_name", format("vnet-mgmt-platform-%s", var.location)))
  management_runner_subnet_name            = try(local.platform_outputs.management_runner_subnet_name, lookup(local.platform_replacements, "management_runner_subnet_name", format("snet-mgmt-platform-%s", var.location)))
  management_private_endpoints_subnet_name = try(local.platform_outputs.management_private_endpoints_subnet_name, lookup(local.platform_replacements, "management_private_endpoints_subnet_name", format("snet-mgmt-platform-pe-%s", var.location)))
  dns_resource_group_name                  = try(local.platform_outputs.dns_resource_group_name, lookup(local.platform_replacements, "dns_resource_group_name", format("rg-hub-dns-%s", var.location)))
  management_resource_group_name           = try(local.platform_outputs.management_resource_group_name, try(local.platform_outputs.templated_inputs.management_resource_settings.resource_group_name, format("rg-management-%s", var.location)))
  log_analytics_workspace_name             = try(local.platform_outputs.log_analytics_workspace_name, try(local.platform_outputs.templated_inputs.management_resource_settings.log_analytics_workspace_name, format("law-management-%s", var.location)))
  platform_state_storage_account_name      = try(local.platform_outputs.platform_state_storage_account_name, "stoalzmgmuae001wksi")
  platform_state_resource_group_name       = try(local.platform_outputs.platform_state_resource_group_name, "rg-alz-mgmt-state-uaenorth-001")

  runner_resource_group_name = local.management_runner_resource_group_name
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
  my_cidr_slash_24    = "${join(".", slice(local.my_ip_address_split, 0, 3))}.0/24"
}

resource "random_string" "unique_name" {
  length  = 4
  upper   = false
  numeric = true
  special = false
}
