#!/bin/bash
set -e

# Variable Definitions
RG_NAME="rg-crc-ctportfolio"
SUB_ID="<your-subscription-id>"

echo "==> Importing Resource Group..."
terraform import azurerm_resource_group.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME

echo "==> Importing Storage Accounts..."
terraform import azurerm_storage_account.frontend /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Storage/storageAccounts/foliocode
terraform import azurerm_storage_account.functions /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Storage/storageAccounts/rgcrcctportfolioa24c

echo "==> Importing Cosmos DB..."
terraform import azurerm_cosmosdb_account.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.DocumentDB/databaseAccounts/crc-cosmos-serverless
terraform import azurerm_cosmosdb_table.visitors /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.DocumentDB/databaseAccounts/crc-cosmos-serverless/tables/VisitorsLog

echo "==> Importing Compute..."
terraform import azurerm_service_plan.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Web/serverFarms/ASP-rgcrcctportfolio-88e7
terraform import azurerm_linux_function_app.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Web/sites/crc-cosmos-visiorcount
terraform import azurerm_application_insights.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Insights/components/crc-cosmos-visiorcount

echo "==> Importing Networking (Front Door)..."
terraform import azurerm_cdn_frontdoor_profile.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Cdn/profiles/cdn-crc-profile-01
terraform import azurerm_cdn_frontdoor_endpoint.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Cdn/profiles/cdn-crc-profile-01/afdEndpoints/crc-cdn-endpoint
terraform import azurerm_cdn_frontdoor_origin_group.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Cdn/profiles/cdn-crc-profile-01/originGroups/crc-cdn-endpoint-Default
terraform import azurerm_cdn_frontdoor_origin.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Cdn/profiles/cdn-crc-profile-01/originGroups/crc-cdn-endpoint-Default/origins/default-origin-a060a70f
terraform import azurerm_cdn_frontdoor_route.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Cdn/profiles/cdn-crc-profile-01/afdEndpoints/crc-cdn-endpoint/routes/crccdnendpoint
terraform import azurerm_cdn_frontdoor_custom_domain.main /subscriptions/$SUB_ID/resourceGroups/$RG_NAME/providers/Microsoft.Cdn/profiles/cdn-crc-profile-01/customDomains/az-chetan-thapliyal-cloud

echo "==> All resources imported successfully."
