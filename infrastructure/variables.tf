variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-crc-ctportfolio"
}

variable "location_primary" {
  description = "Primary location for resources"
  type        = string
  default     = "eastus"
}

variable "location_secondary" {
  description = "Secondary location (West US 2) for backend resources"
  type        = string
  default     = "westus2"
}

variable "storage_account_frontend" {
  description = "Storage account name for static website"
  type        = string
  default     = "foliocode"
}

variable "storage_account_functions" {
  description = "Storage account name for function app"
  type        = string
  default     = "rgcrcctportfolioa24c"
}

variable "cosmos_account_name" {
  description = "Cosmos DB account name"
  type        = string
  default     = "crc-cosmos-serverless"
}

variable "function_app_name" {
  description = "Function app name"
  type        = string
  default     = "crc-cosmos-visiorcount"
}

variable "app_service_plan_name" {
  description = "App Service Plan name"
  type        = string
  default     = "ASP-rgcrcctportfolio-88e7"
}

variable "frontdoor_profile_name" {
  description = "Azure Front Door profile name"
  type        = string
  default     = "cdn-crc-profile-01"
}

variable "frontend_custom_domain" {
  description = "Custom domain for the frontend"
  type        = string
  default     = "az.chetan-thapliyal.cloud"
}
