variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
  default = {
    resource_group_name                 = "rg-$${workload}-$${environment}-$${location}-$${sequence}"
    log_analytics_workspace_name        = "law-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_network_name                = "vnet-$${workload}-$${environment}-$${location}-$${sequence}"
    network_security_group_name         = "nsg-$${workload}-$${environment}-$${location}-$${sequence}"
    key_vault_name                      = "kv$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    storage_account_name                = "sto$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    user_assigned_managed_identity_name = "uami-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_machine_name                = "vm-$${workload}-$${environment}-$${location}-$${sequence}"
    network_interface_name              = "nic-$${workload}-$${environment}-$${location}-$${sequence}"
  }
}

variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uksouth')"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens"
  }
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}

