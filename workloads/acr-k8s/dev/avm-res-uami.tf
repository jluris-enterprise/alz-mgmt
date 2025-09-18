module "avm-res-managedidentity-userassignedidentity" {
  source  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version = "0.3.4"

  name                = local.resource_names.uami_name
  location            = var.location
  resource_group_name = module.avm-res-resources-resourcegroup.name
  tags                = var.tags
  
}
