resource "azuread_user" "sql_admin" {
  user_principal_name = var.sql_useradmin_login
  display_name        = "SQL Admin"
  password            = var.sql_useradmin_password
}

resource "azurerm_mssql_server" "sql" {
  name                         = "sql${var.project_name}lc"
  resource_group_name          = azurerm_resource_group.rg_tp_cloud.name
  location                     = azurerm_resource_group.rg_tp_cloud.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_password

  azuread_administrator {
    login_username = azuread_user.sql_admin.user_principal_name
    object_id      = azuread_user.sql_admin.object_id
  }

}

resource "azurerm_mssql_database" "main" {
  name                = "sqldb${var.project_name}lc"
  server_id           = azurerm_mssql_server.sql.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  sku_name            = "S0"
  zone_redundant      = true
  max_size_gb         = 5
}