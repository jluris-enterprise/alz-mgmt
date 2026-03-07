locals {
  management_runner_nsg_rules = {
    deny_inbound_internet = {
      name                       = "deny-inbound-internet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    allow_outbound_dns_azure = {
      name                       = "allow-outbound-dns-azure"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "168.63.129.16"
    }
    allow_outbound_https_internet = {
      name                       = "allow-outbound-https-internet"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
    deny_outbound_internet = {
      name                       = "deny-outbound-internet"
      priority                   = 400
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
  }
}

resource "azurerm_virtual_network" "management_runners" {
  name                = module.config.custom_replacements.management_runner_virtual_network_name
  location            = module.config.custom_replacements.starter_location_01
  resource_group_name = azurerm_resource_group.management_runners.name
  address_space       = [module.config.custom_replacements.management_runner_virtual_network_address_space]
  tags                = module.config.tags

  provider = azurerm.management
}

resource "azurerm_subnet" "management_runners" {
  name                 = module.config.custom_replacements.management_runner_subnet_name
  resource_group_name  = azurerm_resource_group.management_runners.name
  virtual_network_name = azurerm_virtual_network.management_runners.name
  address_prefixes     = [module.config.custom_replacements.management_runner_subnet_address_prefix]

  provider = azurerm.management
}

resource "azurerm_subnet" "management_private_endpoints" {
  name                 = module.config.custom_replacements.management_private_endpoints_subnet_name
  resource_group_name  = azurerm_resource_group.management_runners.name
  virtual_network_name = azurerm_virtual_network.management_runners.name
  address_prefixes     = [module.config.custom_replacements.management_private_endpoints_subnet_address_prefix]

  provider = azurerm.management
}

resource "azurerm_network_security_group" "management_runners" {
  name                = module.config.custom_replacements.management_runner_nsg_name
  location            = module.config.custom_replacements.starter_location_01
  resource_group_name = azurerm_resource_group.management_runners.name
  tags                = module.config.tags

  provider = azurerm.management
}

resource "azurerm_network_security_rule" "management_runners" {
  for_each = local.management_runner_nsg_rules

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.management_runners.name
  network_security_group_name = azurerm_network_security_group.management_runners.name

  provider = azurerm.management
}

resource "azurerm_subnet_network_security_group_association" "management_runners" {
  subnet_id                 = azurerm_subnet.management_runners.id
  network_security_group_id = azurerm_network_security_group.management_runners.id

  provider = azurerm.management
}

data "azurerm_virtual_network" "connectivity_hub_primary" {
  name                = module.config.custom_replacements.primary_virtual_network_name
  resource_group_name = module.config.custom_replacements.connectivity_hub_primary_resource_group_name

  provider = azurerm.connectivity
}

resource "azurerm_virtual_network_peering" "management_runners_to_hub" {
  name                         = "peer-runners-to-hub"
  resource_group_name          = azurerm_resource_group.management_runners.name
  virtual_network_name         = azurerm_virtual_network.management_runners.name
  remote_virtual_network_id    = data.azurerm_virtual_network.connectivity_hub_primary.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = module.config.custom_replacements.management_runner_peering_use_remote_gateways

  provider = azurerm.management
}

resource "azurerm_virtual_network_peering" "hub_to_management_runners" {
  name                         = "peer-hub-to-runners"
  resource_group_name          = module.config.custom_replacements.connectivity_hub_primary_resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.connectivity_hub_primary.name
  remote_virtual_network_id    = azurerm_virtual_network.management_runners.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = module.config.custom_replacements.management_runner_peering_allow_gateway_transit

  provider = azurerm.connectivity
}
