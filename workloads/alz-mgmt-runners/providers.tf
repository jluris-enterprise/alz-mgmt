terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.57"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.7"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>2.8"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>3.0.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  resource_provider_registrations = "extended"
  subscription_id                 = "42dedbdb-3ad0-438c-a796-66bb1c08686a"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "management"
  subscription_id                 = "42dedbdb-3ad0-438c-a796-66bb1c08686a"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "connectivity"
  subscription_id                 = "2bb0667b-d883-4406-b19a-a3083ba05bd8"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
