resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location_secondary
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "main" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location_secondary

  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id

  site_config {
    application_stack {
      python_version = "3.12"
    }
    cors {
      allowed_origins = ["*"]
    }
  }

  app_settings = {
    "COSMOS_DB_CONNECTION_STRING"    = azurerm_cosmosdb_account.main.primary_sql_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.main.instrumentation_key
  }

  https_only = true
}

resource "azurerm_application_insights" "main" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location_secondary
  application_type    = "web"
}
