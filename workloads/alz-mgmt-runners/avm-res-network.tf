module "avm-res-network-virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  parent_id           = module.resource_group.resource_id
  subnets             = data.terraform_remote_state.alz_platform.outputs.management_runner_subnets
  address_space       = data.terraform_remote_state.alz_platform.outputs.management_runner_vnet_address_space
  location            = var.location
  name                = data.terraform_remote_state.alz_platform.outputs.management_runner_vnet_name
  tags                = var.tags
}