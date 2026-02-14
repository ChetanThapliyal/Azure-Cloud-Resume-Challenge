output "storage_account_frontend_endpoint" {
  description = "The primary endpoint for the static website"
  value       = azurerm_storage_account.frontend.primary_web_endpoint
}

output "function_app_url" {
  description = "The default hostname of the function app"
  value       = "https://${azurerm_linux_function_app.main.default_hostname}"
}

output "frontdoor_endpoint_hostname" {
  description = "The hostname of the Front Door endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
}

output "cosmosdb_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.main.endpoint
}
