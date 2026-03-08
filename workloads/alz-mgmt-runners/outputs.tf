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
  value = local.dns_resource_group_name
}

output "management_runner_subnet_id" {
  value = data.azurerm_subnet.subnet_management_runners.id
}

output "management_pe_subnet_id" {
  value = data.azurerm_subnet.subnet_management_pe.id
}

output "key_vault_id" {
  value = module.key_vault.resource_id
}

output "runner_vm_id" {
  value = {
    for vm_name, vm_module in module.virtual_machine :
    vm_name => vm_module.resource_id
  }
}

output "runner_vm_system_assigned_identity_principal_id" {
  value = {
    for vm_name, vm_module in module.virtual_machine :
    vm_name => vm_module.system_assigned_mi_principal_id
  }
}

