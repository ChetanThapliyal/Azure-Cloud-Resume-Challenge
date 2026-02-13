<div align="center">

# ☁️ Azure Cloud Resume Challenge

**A full-stack serverless portfolio deployed entirely on Microsoft Azure**

[![Deploy Frontend](https://github.com/ChetanThapliyal/Azure-Cloud-Resume-Challenge/actions/workflows/azure-deploy-frontend.yml/badge.svg)](https://github.com/ChetanThapliyal/Azure-Cloud-Resume-Challenge/actions/workflows/azure-deploy-frontend.yml)
![Azure](https://img.shields.io/badge/Azure-0078D4?logo=microsoftazure&logoColor=white)
![Hugo](https://img.shields.io/badge/Hugo-FF4088?logo=hugo&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

[**🌐 Live Site**](https://az.chetan-thapliyal.cloud) · [**📖 Blog**](https://blog.chetan-thapliyal.cloud) · [**📄 Docs**](docs/)

</div>

---

## Architecture

```mermaid
flowchart LR
    U["👤 Visitor"] -->|HTTPS| FD["Azure Front Door\n(TLS + CDN)"]

    subgraph Frontend
        FD -->|Static Assets| BS["Azure Blob Storage\n($web container)"]
    end

    subgraph Backend
        FD -->|/api/counter| AF["Azure Functions\n(Python)"]
        AF <-->|Read/Write| CD[("Azure Cosmos DB")]
    end

    subgraph CI/CD
        GH["GitHub Actions"] -->|Build Hugo &\nUpload Blobs| BS
        GH -->|Purge Cache| FD
    end

    style FD fill:#0078D4,color:#fff
    style BS fill:#0078D4,color:#fff
    style AF fill:#0078D4,color:#fff
    style CD fill:#0078D4,color:#fff
    style GH fill:#24292e,color:#fff
```

## Tech Stack

| Layer | Technology | Purpose |
|:---|:---|:---|
| **Frontend** | Hugo  | Static site generator for the portfolio |
| **Hosting** | Azure Blob Storage (`$web`) | Static website hosting |
| **CDN / TLS** | Azure Front Door (Standard) | Global edge caching, custom domain, managed TLS |
| **API** | Azure Functions (Python) | Serverless REST API for visitor counter |
| **Database** | Azure Cosmos DB | NoSQL store for visitor count persistence |
| **IaC** | Terraform | Declarative infrastructure provisioning |
| **CI/CD** | GitHub Actions | Automated build, deploy, and cache purge on push |
| **DNS** | Custom domain (`az.chetan-thapliyal.cloud`) | Branded endpoint with HTTPS |

## Project Structure

```
Azure-Cloud-Resume-Challenge/
├── frontend/                    # Hugo static site
│   ├── config.toml              # Site configuration
│   ├── content/english/         # Page content (projects, blogs, author)
│   ├── layouts/partials/        # Template overrides
│   ├── static/images/           # Logo, favicon, project images
│   └── themes/gofolium/         # Hugo theme
├── backend/                     # Serverless API
│   ├── visitorCounter/          # Azure Function — visitor counter
│   │   ├── __init__.py          # Function handler (Cosmos DB binding)
│   │   └── function.json        # Input/output bindings
│   ├── host.json                # Function host configuration
│   └── requirements.txt         # Python dependencies
├── infrastructure/              # Terraform IaC
├── docs/                        # Documentation
│   ├── deployment.md            # Build & deploy guide
│   └── frontdoorMigration.md    # CDN → Front Door migration runbook
└── .github/workflows/
    └── azure-deploy-frontend.yml  # CI/CD pipeline
```

## How It Works

1. **Visitor opens** `az.chetan-thapliyal.cloud`
2. **Azure Front Door** terminates TLS and serves cached static assets from the nearest edge PoP
3. On cache miss, Front Door fetches from the **Azure Blob Storage** origin (`$web` container)
4. The page JavaScript calls the `/api/counter` endpoint
5. **Azure Functions** reads/increments the counter in **Cosmos DB** and returns the updated count
6. The visitor counter updates live on the page

## Quick Start

### Prerequisites

- [Hugo Extended](https://gohugo.io/installation/) ≥ v0.110
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- An Azure subscription with the resources provisioned (see `infrastructure/`)

### Local Development

```bash
# Clone the repo
git clone https://github.com/ChetanThapliyal/Azure-Cloud-Resume-Challenge.git
cd Azure-Cloud-Resume-Challenge/frontend

# Start Hugo dev server
hugo server -D

# Site available at http://localhost:1313
```

### Deploy to Azure

```bash
# Build production assets
cd frontend && hugo --minify

# Upload to Blob Storage
az storage blob delete-batch --account-name <STORAGE_ACCOUNT> --source '$web'
az storage blob upload-batch --account-name <STORAGE_ACCOUNT> \
  --destination '$web' --source public/ --overwrite

# Purge Front Door cache
az afd endpoint purge \
  --endpoint-name <ENDPOINT> \
  --profile-name <PROFILE> \
  --resource-group <RG> \
  --content-paths "/*"
```

> [!TIP]
> Pushing to `main` triggers the GitHub Actions workflow, which handles the full build → upload → purge pipeline automatically.

## CI/CD Pipeline

The [GitHub Actions workflow](.github/workflows/azure-deploy-frontend.yml) runs on every push to `main`:

```
Checkout → Setup Hugo → Build (--minify) → Azure Login → Delete stale blobs → Upload → Purge Front Door
```

**Required secrets:**

| Secret | Description |
|:---|:---|
| `AZURE_CREDENTIALS` | Service principal JSON for `az login` |
| `AZURE_STORAGE_ACCOUNT_NAME` | Storage account name (e.g. `foliocode`) |
| `AZURE_RESOURCE_GROUP` | Resource group name |

## Documentation

| Document | Description |
|:---|:---|
| [deployment.md](docs/deployment.md) | Step-by-step build and deploy guide with troubleshooting |
| [frontdoorMigration.md](docs/frontdoorMigration.md) | Azure CDN → Front Door migration runbook |

## Key Learnings

- Architecting a **serverless full-stack application** on Azure with zero VM management
- Configuring **Azure Front Door** with custom domains, managed TLS certificates, and cache rules
- Building **CI/CD pipelines** with GitHub Actions for infrastructure and application deployment
- Using **Cosmos DB bindings** with Azure Functions for low-latency data access
- Migrating from **Azure CDN Classic** to **Azure Front Door Standard** with zero downtime
- Implementing **Infrastructure as Code** with Terraform for reproducible cloud environments

## Acknowledgements

This project is part of the [**Cloud Resume Challenge**](https://cloudresumechallenge.dev/) by [Forrest Brazeal](https://forrestbrazeal.com/) — adapted for Microsoft Azure.

---

<div align="center">

**Built with ☁️ by [Chetan Thapliyal](https://www.linkedin.com/in/chetanthapliyal/)**

</div>
