# This is a local map that defines the actual values to substitute into the templates:
locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    sequence       = format("%03d", var.resource_name_sequence_start)
    uniqueness     = random_string.unique_name.id
    location_short = var.resource_name_location_short == "" ? module.regions.regions_by_name[var.location].geo_code : var.resource_name_location_short
  }

  resource_names = { for k, v in var.resource_name_templates : k => templatestring(v, local.name_replacements) }
  uami_names     = { for k, v in var.user_assigned_managed_identities : k => templatestring(v.name, local.name_replacements) }
  fic_subjects = { for k, v in var.fic_subjects : k => {
    audience = v.audience
    issuer   = v.issuer
    subject  = v.subject
  } }
}

locals {
  subnets = { for key, value in var.subnets : key => {
    name             = key
    address_prefixes = [module.avm-utl-network-ip-addresses.address_prefixes[key]]
    # network_security_group = value.has_network_security_group ? {
    #   id = module.network_security_group.resource_id
    # } : null
    # nat_gateway = value.has_nat_gateway ? {
    #   id = module.nat_gateway.resource_id
    # } : null
    delegation = length(value.delegation) > 0 ? value.delegation : null
    # delegation = value.delegation != null ? value.delegation : null
    }
  }
}
