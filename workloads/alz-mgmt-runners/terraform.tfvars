location = "uaenorth"

tags = {
  environment = "management-runners"
  workload    = "github-actions-runners"
}

virtual_machines = {
  runner1 = {
    computer_name         = "alz-runner-01"
    patch_assessment_mode = "AutomaticByPlatform"
    os_type               = "linux"
    sku_size              = "Standard_D2s_v5"
    zone                  = "1"
    priority              = "Spot"
    eviction_policy       = "Deallocate"
    max_bid_price         = -1 # Use -1 for max price to allow up to the on-demand price
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
    extensions = {
      AzureMonitorLinuxAgent = {
        name                       = "AzureMonitorLinuxAgent"
        publisher                  = "Microsoft.Azure.Monitor"
        type                       = "AzureMonitorLinuxAgent"
        type_handler_version       = "1.39"
        auto_upgrade_minor_version = true
      }
      AADSSHLoginForLinux = {
        name                       = "AADSSHLoginForLinux"
        publisher                  = "Microsoft.Azure.ActiveDirectory"
        type                       = "AADSSHLoginForLinux"
        type_handler_version       = "1.0"
        auto_upgrade_minor_version = false
      }
    }
  }
}

key_vault = {
  sku_name = "standard"
  keys = {
    github_actions_runner_key = {
      name     = "github-actions-runner-key"
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
    allocation_method = "Static"
    sku               = "Standard"
  }
}
