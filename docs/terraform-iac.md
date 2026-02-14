# Terraform Infrastructure as Code (IaC) Documentation

This document outlines the implementation of Terraform Infrastructure as Code for the Azure Cloud Resume Challenge. The goal was to migrate existing manually created resources into a managed Terraform state for better maintainability, security, and reproducibility.

## Architecture Overview

The infrastructure is modularized into the following components:

- **Storage**: Two storage accounts (Frontend static website and Function App backend).
- **Database**: Cosmos DB account using Table API (Serverless).
- **Compute**: Linux Function App with a Consumption (Y1) Service Plan.
- **Networking**: Azure Front Door (Standard) profile with custom domain and managed TLS.
- **Monitoring**: Application Insights for the Function App.

## Implementation Details

### Remote State Management

The Terraform state is stored securely in an Azure Storage container to enable collaboration and state locking.

- **Resource Group**: `rg-terraform-state`
- **Storage Account**: `stcttfstatemn6tib`
- **Container**: `tfstate`

### Modular Structure

Instead of a single large file, the configuration is split logically:

- [providers.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/providers.tf): Backend and provider configuration.
- [variables.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/variables.tf): Parameterized values for environment flexibility.
- [main.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/main.tf): Root resource group definition.
- [storage.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/storage.tf): Storage resources.
- [database.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/database.tf): Cosmos DB and Tables.
- [compute.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/compute.tf): Functions and App Insights.
- [networking.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/networking.tf): Front Door and Custom Domains.
- [outputs.tf](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/outputs.tf): Key endpoints and resource IDs.

## Security Improvements

1. **HTTPS Redirection**: Enabled `https_redirect_enabled = true` on the Front Door route to ensure all traffic is encrypted.
2. **Dynamic Secrets**: The Function App connection strings are dynamically retrieved from the Cosmos DB resource using `primary_sql_connection_string`, avoiding hardcoded secrets.
3. **Managed TLS**: Front Door uses Managed Certificates for the custom domain.
4. **Least Privilege**: Storage accounts enforce HTTPS-only traffic.

## Migration Process

The existing resources were brought under management using a systematic import process:

1. **Discovery**: Resources were mapped using `aztfexport` to ensure all properties matched the live environment.
2. **Import**: A custom script [import.sh](file:///home/owl/Apex/My-Projects/Azure-Cloud-Resume-Challenge/infrastructure/import.sh) was used to link the live Resource IDs to the Terraform state.
3. **Verification**: `terraform plan` was run to ensure that the code exactly represents the living infrastructure, with only intentional security changes flagged for update.

## Maintenance Commands

- **Initialize**: `terraform init`
- **Check Changes**: `terraform plan`
- **Apply Changes**: `terraform apply`
- **Format Code**: `terraform fmt -recursive`
- **Validate**: `terraform validate`
