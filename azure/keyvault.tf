resource "random_string" "kv_unique" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.project_name}-${random_string.kv_unique.result}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg_tp_cloud.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 90
  access_policy               = [] # Utilisation du mode RBAC
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_secret" "sql_conn" {
  name         = "sql-connection-string"
  value        = var.sql_connection_string
  key_vault_id = azurerm_key_vault.main.id
}
