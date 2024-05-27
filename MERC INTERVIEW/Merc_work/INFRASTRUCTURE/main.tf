provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "example-resources"
  location = "East US"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "IOT_aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_log_analytics_workspace" "IOT_aks" {
  name                = "IOT_aks-log-analytics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name = "aks-monitoring"
  target_resource_id = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.IOT_aks.id

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
resource "azurerm_key_vault" "kv" {
  name                = "IOT KEY"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}
