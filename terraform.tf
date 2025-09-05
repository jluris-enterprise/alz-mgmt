terraform {
  required_version = "~> 1.12"
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "0.18.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  backend "azurerm" {
    # subscription_id      = "42dedbdb-3ad0-438c-a796-66bb1c08686a"
    # resource_group_name  = "rg-alz-mgmt-state-uksouth-001"
    # storage_account_name = "stoalzmgmuks001ckue"
    # container_name       = "mgmt-tfstate"
    # key                  = "terraform.tfstate"

    # use_azuread_auth = true
  }
}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azapi" {
  skip_provider_registration = true
  subscription_id            = var.subscription_id_management
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "management"
  subscription_id                 = var.subscription_id_management
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "connectivity"
  subscription_id                 = var.subscription_id_connectivity
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "identity"
  subscription_id                 = var.subscription_id_identity
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

}

provider "azapi" {
  alias                      = "connectivity"
  skip_provider_registration = true
  subscription_id            = var.subscription_id_connectivity
}
