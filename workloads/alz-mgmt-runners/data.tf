data "azurerm_resource_group" "runners" {
  name     = "rg-platform-runners-uaenorth"
  provider = azurerm.management
}

data "azurerm_virtual_network" "vnet_management_runners" {
  name                = "vnet-platform-mgmt-uaenorth"
  resource_group_name = data.azurerm_resource_group.runners.name
  provider            = azurerm.management
}

data "azurerm_subnet" "subnet_management_runners" {
  name                 = "snet-platform-runners"
  virtual_network_name = data.azurerm_virtual_network.vnet_management_runners.name
  resource_group_name  = data.azurerm_resource_group.runners.name
  provider             = azurerm.management
}

data "azurerm_subnet" "subnet_management_private_endpoints" {
  name                 = "snet-platform-runners-pe-uaenorth"
  virtual_network_name = data.azurerm_virtual_network.vnet_management_runners.name
  resource_group_name  = data.azurerm_resource_group.runners.name
  provider             = azurerm.management
}