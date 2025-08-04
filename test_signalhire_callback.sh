#!/bin/bash

# Test SignalHire callback endpoint
CALLBACK_URL="https://jecyykhmabcvguvjghll.supabase.co/functions/v1/signalhire-callback"
API_KEY="$(grep VITE_SUPABASE_ANON_KEY .env | cut -d'=' -f2)"

echo "Testing SignalHire callback endpoint..."

# Test 1: With authorization header (should work)
echo "Test 1: With authorization header"
curl -s -X POST "$CALLBACK_URL?requestId=test123&vendorId=test456" \
  -H "apikey: $API_KEY" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '[{"item":"test","status":"success","candidate":{"uid":"123","fullName":"Test CEO","contacts":[{"type":"email","value":"test@company.com"}]}}]' | jq '.'

echo -e "\nTest 2: Without authorization header (should fail)"
curl -s -X POST "$CALLBACK_URL?requestId=test456&vendorId=test789" \
  -H "apikey: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '[{"item":"test","status":"success","candidate":{"uid":"456","fullName":"Test CEO 2","contacts":[{"type":"email","value":"test2@company.com"}]}}]' | jq '.'

echo -e "\nTest completed." 