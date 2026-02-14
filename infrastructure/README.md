# Azure Cloud Resume Challenge - Infrastructure (Terraform)

This directory contains the Infrastructure as Code (IaC) for the Azure Cloud Resume Challenge project.

## Directory Structure

- `providers.tf`: Terraform and Provider configuration.
- `variables.tf`: Input variables.
- `main.tf`: Resource Group definition.
- `storage.tf`: Azure Storage Accounts.
- `database.tf`: Azure Cosmos DB.
- `compute.tf`: Azure Functions and Monitoring.
- `networking.tf`: Azure Front Door and Custom Domains.
- `outputs.tf`: Infrastructure outputs.
- `import.sh`: Script used to import existing resources.

## Quick Start

1. Ensure you are logged into Azure: `az login`
2. Initialize Terraform: `terraform init`
3. Check the current plan: `terraform plan`
4. Apply any changes (e.g. security fixes): `terraform apply`

## Documentation

For a detailed overview of the implementation, architecture, and security improvements, refer to the [IaC Documentation](../docs/terraform-iac.md).
