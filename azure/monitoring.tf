resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "appgw_diag" {
  name                       = "appgw-diagnostics"
  target_resource_id         = azurerm_application_gateway.appgw_waf_v2.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }
  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }
  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }
}

resource "azurerm_monitor_diagnostic_setting" "sql_diag" {
  name                       = "sql-diagnostics"
  target_resource_id         = azurerm_mssql_database.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  enabled_log {
    category = "SQLSecurityAuditEvents"
  }
  enabled_log {
    category = "SQLInsights"
  }
}


resource "azurerm_monitor_diagnostic_setting" "nsg_diag" {
  name                       = "nsg-diagnostics"
  target_resource_id         = azurerm_network_security_group.frontend.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }
  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

# Alertes
resource "azurerm_monitor_metric_alert" "backend_unhealthy" {
  name                = "BackendUnhealthyAlert"
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  scopes              = [azurerm_application_gateway.appgw_waf_v2.id]
  description         = "Backend unhealthy > 50%"
  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 50
  }
}

resource "azurerm_monitor_metric_alert" "sql_dtu" {
  name                = "SQLDTUAlert"
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  scopes              = [azurerm_mssql_database.main.id]
  description         = "SQL DTU > 80%"
  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "dtu_consumption_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
}

# resource "azurerm_monitor_metric_alert" "waf_blocked" {
#   name                = "WAFBlockedRequestsAlert"
#   resource_group_name = azurerm_resource_group.rg_tp_cloud.name
#   scopes              = [azurerm_application_gateway.appgw_waf_v2.id]
#   description         = "WAF blocked requests > 100/min"
#   criteria {
#     metric_namespace  = "Microsoft.Network/applicationGateways"
#     metric_name       = "BlockedRequestCount"
#     aggregation       = "Total"
#     operator          = "GreaterThan"
#     threshold         = 100
#   }
#   frequency           = "PT1M"
# }
