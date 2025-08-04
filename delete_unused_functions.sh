#!/bin/bash

echo "Deleting unused edge functions from Supabase..."
echo "This will only delete the functions, not any data."

# List of unused functions to delete
functions_to_delete=(
    "address-validator"
    "ai-bulk-enrichment"
    "ai-extract"
    "comprehensive-vendor-enrichment"
    "debug-discovery-filtering"
    "discover-vendors"
    "discover-vendors-stream"
    "enhanced-isv-discovery"
    "enrich-and-store-vendor"
    "enrich-vendor-details"
    "google-maps-business"
    "real-time-products"
    "validate-database"
    "validate-vendors"
)

for func in "${functions_to_delete[@]}"; do
    echo "Deleting function: $func"
    supabase functions delete "$func"
    echo "---"
done

echo "Function deletion complete!" 