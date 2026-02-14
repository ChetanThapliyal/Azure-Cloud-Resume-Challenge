resource "azurerm_storage_account" "frontend" {
  name                       = var.storage_account_frontend
  resource_group_name        = var.resource_group_name
  location                   = var.location_primary
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  access_tier                = "Hot"
  https_traffic_only_enabled = true

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_storage_account" "functions" {
  name                     = var.storage_account_functions
  resource_group_name      = var.resource_group_name
  location                 = var.location_secondary
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}
