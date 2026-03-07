output "management_runner_resource_group_name" {
  value = local.runner_resource_group.name
}

output "management_runner_virtual_network_name" {
  value = data.azurerm_virtual_network.vnet_management_runners.name
}

output "management_runner_subnet_name" {
  value = data.azurerm_subnet.subnet_management_runners.name
}

output "management_pe_subnet_name" {
  value = data.azurerm_subnet.subnet_management_pe.name
}

output "dns_resource_group_name" {
  value = data.terraform_remote_state.alz_platform.outputs.dns_resource_group_name
}

output "management_runner_subnet_id" {
  value = data.azurerm_subnet.subnet_management_runners.id
}

output "management_pe_subnet_id" {
  value = data.azurerm_subnet.subnet_management_pe.id
}
