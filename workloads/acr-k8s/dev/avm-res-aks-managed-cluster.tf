module "aks_cluster" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.3.0"

  resource_group_name = module.resource_group.name
  location            = var.location
  name                = local.resource_names.aks_cluster_name
  tags                = var.tags

  default_node_pool = {
    name                         = "system01"
    temporary_name_for_rotation  = "system01b"
    vm_size                      = "Standard_D2s_v3" # check vm sku availability for your region
    os_disk_size_gb              = 30
    sku_tier                     = "Free"
    vnet_subnet_id               = module.virtual_network.subnets["node"].resource_id
    pod_subnet_id                = module.virtual_network.subnets["pods"].resource_id
    auto_scaling_enabled         = true
    max_count                    = 1
    max_pods                     = 64
    min_count                   = 1
    only_critical_addons_enabled = true
    zones                        = [1, 2, 3]
    upgrade_settings = {
      max_surge = "10%"
    }
  }

  auto_scaler_profile = {
    expander = "least-waste"
  }

  automatic_upgrade_channel = "stable"

  azure_active_directory_role_based_access_control = {
    azure_rbac_enabled = true
    # tenant_id          = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = ["1c1de890-2a46-4597-8f88-0e26161cf9a2"]
  }
  # defender_log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  dns_prefix = "cniexample"
  kubelet_identity = {
    client_id                 = data.azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = data.azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = data.azurerm_user_assigned_identity.kubelet.id
  }
  maintenance_window_auto_upgrade = {
    frequency   = "Weekly"
    interval    = "1"
    day_of_week = "Sunday"
    duration    = 4
    utc_offset  = "+00:00"
    start_time  = "00:00"
    start_date  = "2024-10-15T00:00:00Z"
  }
  maintenance_window_node_os = {
    frequency   = "Weekly"
    interval    = "1"
    day_of_week = "Sunday"
    duration    = 4
    utc_offset  = "+00:00"
    start_time  = "00:00"
    start_date  = "2024-10-15T00:00:00Z"
  }
  managed_identities = {
    system_assigned            = false
    user_assigned_resource_ids = [module.user_assigned_managed_identity["kubernetes"].resource_id]
  }

  network_profile = {
    network_plugin     = "azure"
    network_data_plane = "azure"
    # network_plugin_mode = "overlay" # remove if your using pod_subnet_id
    outbound_type = "loadBalancer"
  }
  node_os_channel_upgrade = "Unmanaged"

  node_pools = {
    unp1 = {
      name                        = "userpool1"
      temporary_name_for_rotation = "userpool1b"
      vm_size                     = "Standard_D2s_v3"
      max_count                   = 1
      max_pods                    = 30
      min_count                   = 1
      os_disk_size_gb             = 30
      os_disk_type                = "Ephemeral" # "Ephemeral" uses temporary storage
      spot_max_price              = -1          # -1 means "pay up to the current market price" (default behavior).
      priority                    = "Spot"
      eviction_policy             = "Delete"
      vnet_subnet_id              = module.virtual_network.subnets["node"].resource_id
      pod_subnet_id               = module.virtual_network.subnets["pods"].resource_id
      auto_scaling_enabled        = true
      # Upgrade settings doesnt support spot nodes
      # upgrade_settings = {
      #   max_surge = "10%"
      # }
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      # node_taints = [
      #   "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      # ]
    }
    unp2 = {
      name                        = "userpool2"
      temporary_name_for_rotation = "userpool2b"
      vm_size                     = "Standard_D2s_v3"
      auto_scaling_enabled        = true
      max_count                   = 1
      max_pods                    = 30
      min_count                   = 1
      os_disk_size_gb             = 30
      os_disk_type                = "Ephemeral"
      spot_max_price              = -1
      priority                    = "Spot"
      eviction_policy             = "Delete"
      vnet_subnet_id              = module.virtual_network.subnets["node"].resource_id
      pod_subnet_id               = module.virtual_network.subnets["pods"].resource_id
      upgrade_settings = {
        max_surge = "10%"
      }
      # No taints - allows regular pods to schedule on this spot node pool
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      # node_taints = [
      #   "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      # ]
    }
  }
  oidc_issuer_enabled    = true
  local_account_disabled = true
  # oms_agent = {
  #   log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  # }
  open_service_mesh_enabled = true
  storage_profile = {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }
  workload_identity_enabled = true

  depends_on = [module.role_assignment["uami_managed_identity_operator"]]
}
