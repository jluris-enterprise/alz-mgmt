module "aks_cluster" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.3.0"

  resource_group_name = module.resource_group.name
  location            = var.location
  name                = local.resource_names.aks_cluster_name
  tags                = var.tags

  default_node_pool = {
    name                         = "default"
    vm_size                      = "Standard_B2s"
    vnet_subnet_id               = module.virtual_network.subnets["node"].resource_id
    pod_subnet_id                = module.virtual_network.subnets["pods"].resource_id
    auto_scaling_enabled         = true
    max_count                    = 4
    max_pods                     = 30
    min_count                    = 2
    only_critical_addons_enabled = true
    upgrade_settings = {
      max_surge = "10%"
    }
  }

  automatic_upgrade_channel = "stable"
  azure_active_directory_role_based_access_control = {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
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
    network_plugin      = "azure"
    network_data_plane  = "azure"
    network_plugin_mode = "overlay"
  }
  node_os_channel_upgrade = "Unmanaged"
  node_pools = {
    unp1 = {
      name                 = "userpool1"
      vm_size              = "Standard_B2s"
      max_count            = 4
      max_pods             = 30
      min_count            = 2
      os_disk_size_gb      = 128
      vnet_subnet_id       = module.virtual_network.subnets["node"].resource_id
      auto_scaling_enabled = true
      upgrade_settings = {
        max_surge = "10%"
      }
    }
    unp2 = {
      name                 = "userpool2"
      vm_size              = "Standard_B2s"
      auto_scaling_enabled = true
      max_count            = 4
      max_pods             = 30
      min_count            = 2
      os_disk_size_gb      = 128
      vnet_subnet_id       = module.virtual_network.subnets["node"].resource_id
      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
  oidc_issuer_enabled = true
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

  depends_on = [module.user_assigned_managed_identity["kubernetes"]]
}
