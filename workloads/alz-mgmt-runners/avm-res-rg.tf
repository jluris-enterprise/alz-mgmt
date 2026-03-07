resource "random_string" "unique_name" {
  length  = 3
  special = false
  upper   = false
  numeric = false
}

module "resource_group" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.1"
  name     = data.azurerm_resource_group.runners.name
  location = var.location
  tags     = var.tags
}
