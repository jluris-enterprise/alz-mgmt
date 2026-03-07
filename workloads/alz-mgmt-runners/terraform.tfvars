location = "uaenorth"

tags = {
  environment = "management-runners"
  workload    = "github-actions-runners"
}

virtual_machines = {
  runner1 = {
    name                  = local.virtual_machine_names.runner1
    os_type               = "linux"
    sku_size              = "Standard_B2s"
    priority              = "Spot"
    eviction_policy       = "Deallocate"
    max_bid_price        = -1 # Use -1 for max price to allow up to the on-demand price
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
    network_interface_ids = []
    managed_identities = {
      system_assigned = true
    }
  }
}

