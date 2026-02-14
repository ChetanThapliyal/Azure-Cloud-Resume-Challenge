resource "azurerm_cosmosdb_account" "main" {
  name                = var.cosmos_account_name
  resource_group_name = var.resource_group_name
  location            = var.location_secondary
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableTable"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "BoundedStaleness"
  }

  geo_location {
    location          = var.location_secondary
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_table" "visitors" {
  name                = "VisitorsLog"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
}
