resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-log-analytics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name = "aks-monitoring"
  target_resource_id = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
