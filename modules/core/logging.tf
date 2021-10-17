resource "azurerm_log_analytics_workspace" "core" {
  name                = "log-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  daily_quota_gb      = "0.5"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "core" {
  name                = "insights-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.core.id
  application_type    = "web"
}