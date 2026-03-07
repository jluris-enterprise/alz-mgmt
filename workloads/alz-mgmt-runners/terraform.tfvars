hub_dns_resource_group_name = "rg-hub-dns-uaenorth"

location = "uaenorth"

tags = {
  environment = "management-runners"
  workload    = "github-actions-runners"
}

virtual_machines = {
  runner1 = {
    os_type         = "linux"
    sku_size        = "Standard_B2s"
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
          }
        }
      }
    }
    managed_identities = {
      system_assigned = true
    }
  }
}

# key_vault = {}