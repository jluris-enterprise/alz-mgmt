locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    sequence       = format("%03d", var.resource_name_sequence_start)
    uniqueness     = random_string.unique_name.id
    location_short = var.resource_name_location_short == "" ? module.avm-utl-regions.regions_by_name[var.location].geo_code : var.resource_name_location_short
  }
  resource_names = { for k, v in var.resource_name_templates : k => templatestring(v, local.name_replacements) }
  virtual_machine_names = {
    for k, v in var.virtual_machines : k => templatestring(v.name, local.name_replacements)
    }
}

locals {
  virtual_machines = {
    for k, v in var.virtual_machines : k => {
      name = templatestring(v.name, local.name_replacements)
      os_type = v.os_type
      sku_size = v.sku_size
      priority = v.priority
      eviction_policy = v.eviction_policy
      max_bid_price = v.max_bidd_price
      os_disk = v.os_disk
      network_interface_ids = v.network_interface_ids
    } 
  }
}