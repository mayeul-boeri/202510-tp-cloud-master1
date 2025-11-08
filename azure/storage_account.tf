resource "azurerm_storage_account" "main" {
  name                     = "sttp${var.project_name}lb" # Remplacez 'lb' par vos initiales si besoin
  resource_group_name      = azurerm_resource_group.rg_tp_cloud.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  #enable_https_traffic_only = true     #probleme ne reconait pas cette option
}

resource "azurerm_storage_container" "private_blob" {
  name                  = "private-blob"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "main" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "transition-to-cool"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
      prefix_match = [azurerm_storage_container.private_blob.name]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
      }
    }
  }

  rule {
    name    = "soft-delete-blobs"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
      prefix_match = [azurerm_storage_container.private_blob.name]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 7
      }
    }
  }
}
