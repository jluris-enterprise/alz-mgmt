module "avm-res-managedidentity-userassignedidentity" {
  source  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version = "0.3.4"

  for_each            = local.uami_names
  name                = each.value
  location            = var.location
  resource_group_name = module.avm-res-resources-resourcegroup.name
  tags                = var.tags
}
