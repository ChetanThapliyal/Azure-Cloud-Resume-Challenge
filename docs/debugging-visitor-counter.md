# Debugging Visitor Counter

## Issue Description

The visitor counter on the portfolio website was not displaying the count, showing "Loading..." or "Unavailable" instead. The browser console indicated a network error when trying to reach the backend Azure Function.

## Investigation Steps

1. **Frontend Inspection**:
    - Checked `themes/gofolium/layouts/partials/footer.html` to understand how the visitor count is fetched.
    - Confirmed the script uses `window.fetch` to call the endpoint defined in configuration.

2. **Configuration Check**:
    - Reviewed `frontend/config.toml` and found the `visitor_counter_endpoint` was set to `https://crc-cosmos-visiorcount.azurewebsites.net/api/visitorCounter`.

3. **Backend Verification**:
    - Examined `backend/visitorCounter/__init__.py` and `function.json`. The code logic for fetching and updating the count from Cosmos DB Table API appeared correct.

4. **Infrastructure Analysis**:
    - Attempted to `curl` the configured endpoint, which failed with `Could not resolve host`.
    - Checked Terraform configuration (`infrastructure/compute.tf`) which defined the Function App name as `crc-cosmos-visiorcount`.
    - Checked Terraform state (`terraform state show azurerm_linux_function_app.main`) and discovered the actual `default_hostname` was `crc-cosmos-visiorcount-g2a6dwd3andyb3dy.westus2-01.azurewebsites.net`.
    - **Note**: Azure Function Apps on Linux consumption plans often receive a generated suffix for uniqueness/DNS availability, which was not reflected in the static configuration.

## Root Cause

The `visitor_counter_endpoint` in `frontend/config.toml` was pointing to a non-existent URL (`crc-cosmos-visiorcount.azurewebsites.net`). The actual deployed Azure Function had a generated suffix (`-g2a6dwd3andyb3dy.westus2-01`).

## Resolution

Updated `frontend/config.toml` with the correct endpoint URL found in the Terraform state.

```toml
# Old
visitor_counter_endpoint = "https://crc-cosmos-visiorcount.azurewebsites.net/api/visitorCounter"

# New
visitor_counter_endpoint = "https://crc-cosmos-visiorcount-g2a6dwd3andyb3dy.westus2-01.azurewebsites.net/api/visitorCounter"
```

## Verification

- Verified the fix by running `curl` against the new endpoint, which successfully returned the visitor count JSON.
