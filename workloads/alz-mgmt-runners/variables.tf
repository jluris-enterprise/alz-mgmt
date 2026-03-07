variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
  default = {
    virtual_machine_name   = "vm-$${workload}-$${environment}-$${location}-$${sequence}"
  }
}

variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  default     = "runners"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters, numbers and hyphens"
  }
  validation {
    condition     = length(var.resource_name_workload) <= 8
    error_message = "The name segment for the workload must be 8 characters or less"
  }
}

variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "mgmt"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_environment))
    error_message = "The name segment for the environment must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.resource_name_environment) <= 4
    error_message = "The name segment for the environment must be 4 characters or less"
  }
}

variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uaenorth')"
  validation {
    condition     = can(regex("^(uaenorth)", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens and uaenorth"
  }
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}

variable "resource_name_sequence_start" {
  type        = number
  description = "The number to use for the resource names"
  default     = 1
  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The number must be between 1 and 999"
  }
}

variable "resource_name_location_short" {
  type        = string
  description = "The short name segment for the location"
  default     = ""
  validation {
    condition     = length(var.resource_name_location_short) == 0 || can(regex("^[a-z]+$", var.resource_name_location_short))
    error_message = "The short name segment for the location must only contain lowercase letters"
  }
  validation {
    condition     = length(var.resource_name_location_short) <= 3
    error_message = "The short name segment for the location must be 3 characters or less"
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to resources"
}

variable "enable_encryption_at_host" {
  type        = bool
  description = "Whether to enable encryption at host for the virtual machines"
  default     = true
}

variable "virtual_machines" {
  description = "A map of virtual machines to create"
  type = map(object({
    name                  = string
    os_type               = string
    sku_size              = string
    location              = string
    priority              = string
    eviction_policy       = string
    max_bid_price        = number
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    network_interface_ids = list(string)
    managed_identities = object({
      system_assigned = bool
    })
  }))
}

