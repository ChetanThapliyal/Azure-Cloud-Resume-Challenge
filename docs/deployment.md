# Frontend Deployment Guide

Deploy the Gofolium Hugo frontend to Azure Blob Storage (static website) behind Azure Front Door.

---

## Architecture

```
Hugo (frontend/) → Build → Azure Storage ($web) → Azure Front Door → az.chetan-thapliyal.cloud
```

| Component         | Resource                                                   |
| ----------------- | ---------------------------------------------------------- |
| Storage Account   | `foliocode` (East US)                                      |
| Static Website    | `foliocode.z13.web.core.windows.net`                       |
| Container         | `$web`                                                     |
| Front Door Profile| `cdn-crc-profile-01`                                       |
| Front Door Endpoint| `crc-cdn-endpoint-bbdwegdvbsbhhsaq.z03.azurefd.net`       |
| Custom Domain     | `az.chetan-thapliyal.cloud`                                |
| Resource Group    | `rg-crc-ctportfolio`                                       |

---

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and logged in (`az login`)
- [Hugo](https://gohugo.io/installation/) installed (extended version)

---

## Step 1 — Build the Hugo Site

```bash
cd frontend

# Set production baseURL in config.toml
# baseURL = "https://az.chetan-thapliyal.cloud/"

# Clean previous build and rebuild
rm -rf public
hugo
```

> [!IMPORTANT]
> Ensure `baseURL` in `config.toml` is set to `https://az.chetan-thapliyal.cloud/` for production builds. Using `/` or `localhost` will break asset paths.

---

## Step 2 — Clear Old Content from Storage

```bash
az storage blob delete-batch \
  --account-name foliocode \
  --source '$web'
```

---

## Step 3 — Upload New Build

```bash
az storage blob upload-batch \
  --account-name foliocode \
  --destination '$web' \
  --source frontend/public \
  --overwrite
```

---

## Step 4 — Purge Front Door Cache

```bash
az afd endpoint purge \
  --endpoint-name crc-cdn-endpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --content-paths "/*" \
  --domains az.chetan-thapliyal.cloud
```

Cache purge can take **2–5 minutes** to propagate across all Front Door PoPs.

---

## Step 5 — Verify Deployment

```bash
# Check the site returns 200
curl -sI https://az.chetan-thapliyal.cloud | head -5

# Verify no localhost references in HTML
curl -s https://az.chetan-thapliyal.cloud | grep -i localhost
```

---

## Quick Deploy (All Steps)

Run all steps as a single script from the project root:

```bash
#!/bin/bash
set -e

echo "==> Building Hugo site..."
cd frontend
rm -rf public
hugo
cd ..

echo "==> Clearing old content..."
az storage blob delete-batch \
  --account-name foliocode \
  --source '$web'

echo "==> Uploading new build..."
az storage blob upload-batch \
  --account-name foliocode \
  --destination '$web' \
  --source frontend/public \
  --overwrite

echo "==> Purging Front Door cache..."
az afd endpoint purge \
  --endpoint-name crc-cdn-endpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --content-paths "/*" \
  --domains az.chetan-thapliyal.cloud

echo "==> Done! Site will update in 2-5 minutes."
```

---

## Troubleshooting

| Issue | Cause | Fix |
| ----- | ----- | --- |
| Old site still showing | Front Door cache | Purge cache and wait 2–5 min, or test with `curl` bypassing browser cache |
| Broken CSS/JS paths | Wrong `baseURL` | Set `baseURL = "https://az.chetan-thapliyal.cloud/"` in `config.toml` and rebuild |
| 404 on subpages | Missing `index.html` | Check Hugo build output, ensure theme is present in `themes/` |
| Permission denied on upload | Missing storage role | Use account key auth (default) or assign `Storage Blob Data Contributor` role |
