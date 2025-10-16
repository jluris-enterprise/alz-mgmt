variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
  default = {
    resource_group_name  = "rg-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_network_name = "vnet-$${workload}-$${environment}-$${location}-$${sequence}"
    aks_cluster_name     = "aks-$${workload}-$${environment}-$${location}-$${sequence}"
    acr_name             = "acr$${environment}$${location_short}$${sequence}$${uniqueness}"
  }
}

variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  default     = "acr-k8s"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters, numbers and hyphens"
  }
  validation {
    condition     = length(var.resource_name_workload) <= 8
    error_message = "The name segment for the workload must be 4 characters or less"
  }
}

variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "dev"
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

variable "user_assigned_managed_identities" {
  type = map(object({
    name = string
  }))
  description = "A map of user assigned managed identities to create"
}

variable "address_space" {
  description = "The address space that is used the virtual network"
  type        = string
  nullable    = false
}

variable "subnets" {
  type = map(object({
    size                       = number
    has_nat_gateway            = bool
    has_network_security_group = bool
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
        service = string
      })
    })), [])
  }))
  description = "The subnets"
}

variable "fic_subjects" {
  type = map(object({
    audience = string
    issuer   = string
    subject  = string
  }))
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to resources"
}

