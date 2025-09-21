module "regions" {
  source           = "Azure/avm-utl-regions/azurerm"
  version          = "0.9.0"
  use_cached_data  = false
  region_filter    = false
  is_recommended   = false
  enable_telemetry = var.enable_telemetry
}

data "azurerm_client_config" "current" {}
