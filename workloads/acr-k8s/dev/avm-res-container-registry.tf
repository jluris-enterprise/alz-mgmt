module "container_registry" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "0.5.0"

  resource_group_name = module.resource_group.name
  location            = var.location
  name                = local.resource_names.acr_name
  tags                = var.tags
}