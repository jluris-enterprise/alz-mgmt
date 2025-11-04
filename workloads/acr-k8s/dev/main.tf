terraform {
  required_version = "~> 1.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.48"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.7"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.6.0"
    }
  }
  # backend "local" {
  #   path = "./terraform.tfstate"
  # }
  backend "azurerm" {}
}

provider "azurerm" {
  resource_provider_registrations = "extended"
  subscription_id                 = "43731ed3-ead8-4406-b85d-18e966dfdb9f"
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
