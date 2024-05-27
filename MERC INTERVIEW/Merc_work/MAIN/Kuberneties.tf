resource "azurerm_kubernetes_cluster" "aks" {
  name                = "IoT cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "exampleaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  addon_profile {
    azure_policy {
      enabled = true
    }
  }

  oms_agent {
    enabled = true
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  }
}

