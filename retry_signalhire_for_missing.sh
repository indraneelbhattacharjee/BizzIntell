#!/bin/bash

INPUT_FILE="vendors_missing_ceo_email.tsv"
SUPABASE_URL="https://jecyykhmabcvguvjghll.supabase.co"
EDGE_FUNCTION_URL="$SUPABASE_URL/functions/v1/signalhire-search"
API_KEY="$(grep VITE_SUPABASE_ANON_KEY .env | cut -d'=' -f2)"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Input file $INPUT_FILE not found!"
  exit 1
fi

while IFS=$'\t' read -r vendor_id company_name company_website; do
  if [ -z "$vendor_id" ] || [ -z "$company_name" ]; then
    continue
  fi
  echo "Re-triggering SignalHire for: $company_name ($vendor_id)"
  curl -s -X POST "$EDGE_FUNCTION_URL" \
    -H "apikey: $API_KEY" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"vendorId": "'$vendor_id'", "companyName": "'$company_name'", "companyDomain": "'$company_website'"}'
  sleep 1
done < "$INPUT_FILE"

echo "All SignalHire requests re-triggered." 