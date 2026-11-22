# State moves for the hub-and-spoke 0.12.0 -> 0.17.2 upgrade.
#
# 0.16 moved private DNS zone virtual network links from azurerm_private_dns_zone_virtual_network_link to azapi.
# The module ships moved blocks only for the standard ALZ zone keys, so links for our non-standard keys would be
# destroyed and recreated. These blocks move them instead.
#
# Safe to delete once this change has been applied everywhere.

moved {
  from = module.hub_and_spoke_vnet[0].module.private_dns_zones["primary"].module.avm_res_network_privatednszone["azure_postgres_sql_database"].azurerm_private_dns_zone_virtual_network_link.this["primary"]
  to   = module.hub_and_spoke_vnet[0].module.private_dns_zones["primary"].module.avm_res_network_privatednszone["azure_postgres_sql_database"].module.virtual_network_links["primary"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.hub_and_spoke_vnet[0].module.private_dns_zones["primary"].module.avm_res_network_privatednszone["custom_jlurisenterprise"].azurerm_private_dns_zone_virtual_network_link.this["primary"]
  to   = module.hub_and_spoke_vnet[0].module.private_dns_zones["primary"].module.avm_res_network_privatednszone["custom_jlurisenterprise"].module.virtual_network_links["primary"].azapi_resource.private_dns_zone_network_link
}

moved {
  from = module.hub_and_spoke_vnet[0].module.private_dns_zones["primary"].module.avm_res_network_privatednszone["azure_aks_mgmt_uaen"].azurerm_private_dns_zone_virtual_network_link.this["primary"]
  to   = module.hub_and_spoke_vnet[0].module.private_dns_zones["primary"].module.avm_res_network_privatednszone["azure_aks_mgmt_uaen"].module.virtual_network_links["primary"].azapi_resource.private_dns_zone_network_link
}
