# Azure CDN to Front Door Migration Guide

> [!IMPORTANT]
> **Azure CDN from Edgio (classic)** is being retired. Microsoft recommends migrating to **Azure Front Door** for improved performance, security, and feature set.

---

## Current CDN Setup

| Property               | Value                                      |
| ---------------------- | ------------------------------------------ |
| **Resource Group**     | `rg-crc-ctportfolio`                       |
| **CDN Profile**        | `cdn-crc-profile-01` (Standard CDN)        |
| **CDN Endpoint**       | `crc-cdn-endpoint.azureedge.net`           |
| **Origin Host**        | `foliocode.z13.web.core.windows.net`       |
| **Custom Domain**      | `crc.chetan-thapliyal.cloud`               |
| **HTTPS**              | Enabled (CDN-managed certificate deployed) |
| **HTTP**               | Allowed                                    |
| **Compression**        | Enabled                                    |
| **Query String Cache** | Ignore Query String                        |

---

## Azure CLI Commands Reference (Corrected)

The Azure CLI uses a **space-separated subcommand** structure. Common mistakes include joining subcommands together (e.g., `endpointlist` instead of `endpoint list`).

### List Resource Groups

```bash
az group list --output table
```

### List CDN Profiles

```bash
az cdn profile list --output table
```

### List CDN Endpoints

```bash
az cdn endpoint list \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --output table
```

### Show CDN Endpoint Details

```bash
az cdn endpoint show \
  --name crc-cdn-endpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --output table
```

### List Custom Domains

```bash
az cdn custom-domain list \
  --endpoint-name crc-cdn-endpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --output table
```

### Purge CDN Cache

```bash
az cdn endpoint purge \
  --name crc-cdn-endpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --content-paths "/*"
```

---

## Migration to Azure Front Door

### Why Migrate?

- **Azure CDN (classic)** profiles may face retirement timelines
- **Azure Front Door** offers integrated WAF, private link origins, advanced routing rules, and better global PoP coverage
- Front Door Standard/Premium tiers consolidate CDN + WAF + routing into a single service

### Pre-Migration Checklist

- [ ] Document current CDN configuration (done above)
- [ ] Note all custom domains and their DNS records
- [ ] Review any CDN rules engine rules or caching rules
- [ ] Validate origin health and accessibility
- [ ] Plan DNS cutover window (TTL reduction)

### Step 1 — Check Migration Compatibility

```bash
# Note: "profile-migration" is hyphenated (preview command group)
az cdn profile-migration check-compatibility \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio
```

### Step 2 — Migrate CDN Profile to Front Door

```bash
# Migrate to Front Door Standard (sufficient for static sites)
az cdn profile-migration migrate \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --sku Standard_AzureFrontDoor
```

> [!NOTE]
> Use `Standard_AzureFrontDoor` for static sites. Use `Premium_AzureFrontDoor` if you need WAF with managed rule sets or Private Link origins.

### Step 3 — Commit the Migration

After validating the migrated Front Door profile:

```bash
az cdn profile-migration commit \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio
```

### Step 4 — Verify Front Door Setup

```bash
# List Front Door profiles
az afd profile list \
  --resource-group rg-crc-ctportfolio \
  --output table

# List Front Door endpoints
az afd endpoint list \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --output table

# List origin groups
az afd origin-group list \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --output table

# List routes
az afd route list \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --endpoint-name crc-cdn-endpoint \
  --output table

# List custom domains
az afd custom-domain list \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --output table
```

### Step 5 — Custom Domain Change (`az.chetan-thapliyal.cloud`)

The custom domain was changed from `crc.chetan-thapliyal.cloud` to `az.chetan-thapliyal.cloud`.

```bash
# Create new custom domain
az afd custom-domain create \
  --custom-domain-name az-chetan-thapliyal-cloud \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --host-name az.chetan-thapliyal.cloud \
  --certificate-type ManagedCertificate \
  --minimum-tls-version TLS12

# Associate with the route (include all custom domains)
az afd route update \
  --route-name crccdnendpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --endpoint-name crc-cdn-endpoint \
  --custom-domains az-chetan-thapliyal-cloud crc-chetan-thapliyal-cloud crc-cdn-endpoint-Migrated
```

### Step 6 — Update DNS Records

Add the following DNS records at your domain registrar:

**Domain Validation (required first):**

| Record Type | Host                           | Value                                  |
| ----------- | ------------------------------ | -------------------------------------- |
| TXT         | `_dnsauth.az.chetan-thapliyal.cloud` | `_t74tgqtsxapet0ado5f3d9zw122lyyw` |

**Traffic Routing (after validation passes):**

| Record Type | Host                       | Value                                                    |
| ----------- | -------------------------- | -------------------------------------------------------- |
| CNAME       | `az.chetan-thapliyal.cloud` | `crc-cdn-endpoint-bbdwegdvbsbhhsaq.z03.azurefd.net` |

> [!CAUTION]
> The TXT validation token **expires on 2026-02-20**. Add the TXT record first. Once domain validation state changes to `Approved`, add the CNAME record.

### Step 7 — Verify Domain Validation

```bash
# Check validation status
az afd custom-domain show \
  --custom-domain-name az-chetan-thapliyal-cloud \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --query "{HostName:hostName, ValidationState:domainValidationState}" \
  --output table
```

---

## Post-Migration Validation

- [ ] Add TXT record `_dnsauth.az.chetan-thapliyal.cloud` → `_t74tgqtsxapet0ado5f3d9zw122lyyw`
- [ ] Wait for `domainValidationState` to become `Approved`
- [ ] Add CNAME record `az.chetan-thapliyal.cloud` → `crc-cdn-endpoint-bbdwegdvbsbhhsaq.z03.azurefd.net`
- [ ] Verify `https://az.chetan-thapliyal.cloud` loads correctly
- [ ] Check HTTPS managed certificate is provisioned and valid
- [ ] Test cache purge works via `az afd endpoint purge`
- [ ] Optionally remove old custom domain `crc.chetan-thapliyal.cloud` once new one is confirmed working

### Post-Migration Purge Command

```bash
az afd endpoint purge \
  --endpoint-name crc-cdn-endpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --content-paths "/*"
```

### Remove Old Custom Domain (Optional, after confirming new domain works)

```bash
# Remove old domain from route first
az afd route update \
  --route-name crccdnendpoint \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio \
  --endpoint-name crc-cdn-endpoint \
  --custom-domains az-chetan-thapliyal-cloud crc-cdn-endpoint-Migrated

# Then delete the old custom domain
az afd custom-domain delete \
  --custom-domain-name crc-chetan-thapliyal-cloud \
  --profile-name cdn-crc-profile-01 \
  --resource-group rg-crc-ctportfolio
```

---

## Useful Links

- [Azure CDN to Front Door Migration Guide](https://learn.microsoft.com/en-us/azure/frontdoor/migrate-cdn-to-front-door)
- [Azure Front Door Documentation](https://learn.microsoft.com/en-us/azure/frontdoor/)
- [az afd CLI Reference](https://learn.microsoft.com/en-us/cli/azure/afd)
- [az cdn CLI Reference](https://learn.microsoft.com/en-us/cli/azure/cdn)
