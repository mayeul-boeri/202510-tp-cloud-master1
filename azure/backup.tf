resource "azurerm_recovery_services_vault" "main" {
  name                = "rsv-${var.project_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  sku                 = "Standard"
  storage_mode_type   = "GeoRedundant"
}

resource "azurerm_backup_policy_vm" "daily_policy" {
  name                = "daily-policy"
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    count = 7
  }
  retention_weekly {
    count = 4
    weekdays = ["Sunday"]
  }
  retention_monthly {
    count = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
}

# resource "azurerm_backup_protected_vm" "vmss" {
#   resource_group_name = azurerm_resource_group.rg_tp_cloud.name
#   recovery_vault_name = azurerm_recovery_services_vault.main.name
#   source_vm_id        = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#   backup_policy_id    = azurerm_backup_policy_vm.daily_policy.id
# }
