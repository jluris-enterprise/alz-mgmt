hub_dns_resource_group_name = "rg-hub-dns-uaenorth"

location = "uaenorth"

tags = {
  environment = "management-runners"
  workload    = "github-actions-runners"
}

virtual_machines = {
  runner1 = {
    os_type         = "linux"
    sku_size        = "Standard_D2s_v5"
    zone            = "1"
    priority        = "Spot"
    eviction_policy = "Deallocate"
    max_bid_price   = -1 # Use -1 for max price to allow up to the on-demand price
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
    network_interfaces = {
      private = {
        name = local.resource_names.network_interface_name
        ip_configurations = {
          private = {
            name                          = "private"
            private_ip_subnet_resource_id = data.azurerm_subnet.subnet_management_runners.id
            public_ip_address_resource_id = "pip-vm-runner"
          }
        }
      }
    }
    managed_identities = {
      system_assigned = true
    }
  }
}

key_vault = {
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  keys = {
    github_actions_runner_key = {
      name    = "github-actions-runner-key"
      key_type = "RSA"
      key_size = 2048
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
      ]
    }
  }
}

public_ip_addresses = {
  pip_runner = {
    location            = var.location
    allocation_method   = "Static"
    sku                 = "Standard"
    resource_group_name = module.resource_group.name
  }
}
