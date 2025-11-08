resource "azurerm_role_assignment" "admins_owner" {
  scope                = azurerm_resource_group.rg_tp_cloud.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.admins.object_id
}

resource "azurerm_role_assignment" "devs_contributor" {
  scope                = azurerm_resource_group.rg_tp_cloud.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.devs.object_id
}

resource "azurerm_role_assignment" "readers_reader" {
  scope                = azurerm_resource_group.rg_tp_cloud.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.readers.object_id
}

resource "azurerm_role_assignment" "vmss_blob_reader" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine_scale_set.web_vmss.identity[0].principal_id
  depends_on           = [azurerm_linux_virtual_machine_scale_set.web_vmss]
}

resource "azurerm_role_assignment" "vmss_kv_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine_scale_set.web_vmss.identity[0].principal_id
  depends_on           = [azurerm_linux_virtual_machine_scale_set.web_vmss]
}
