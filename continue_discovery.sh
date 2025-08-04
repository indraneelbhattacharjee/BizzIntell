#!/bin/bash

# Continue Discovery Script - Creates new jobs with fresh keywords
# This script creates new discovery jobs when previous ones are exhausted

SUPABASE_URL="https://jecyykhmabcvguvjghll.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplY3l5a2htYWJjdmd1dmpnaGxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxNjE3OTksImV4cCI6MjA2NDczNzc5OX0.ivch89osJxBbvYGQEoMdAweaO-py2VzCzqwtLWWIAcw"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating new discovery jobs with fresh keywords..."

# Generate fresh US-focused keywords for each industry
declare -a keywords=(
    # Dental - Fresh variations
    "dental practice software 2024"
    "dental office management system"
    "dental clinic software solutions"
    "dental practice management platform"
    "dental office automation"
    "dental software for small practices"
    "dental practice technology"
    "dental office software reviews"
    "dental practice solutions"
    "dental clinic management software"
    
    # Chiropractic - Fresh variations
    "chiropractic software 2024"
    "chiropractic practice solutions"
    "chiropractic office technology"
    "chiropractic clinic software"
    "chiropractic practice management system"
    "chiropractic office automation"
    "chiropractic software reviews"
    "chiropractic practice technology"
    "chiropractic clinic management"
    "chiropractic office solutions"
    
    # Auto Repair - Fresh variations
    "auto repair software 2024"
    "automotive shop management system"
    "auto repair shop software"
    "automotive business software"
    "auto repair shop technology"
    "automotive shop solutions"
    "auto repair management software"
    "automotive shop automation"
    "auto repair shop systems"
    "automotive business technology"
)

# Create jobs for each keyword
for keyword in "${keywords[@]}"; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating job for: $keyword"
    
    response=$(curl -s -X POST \
        "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/bulk_discovery_jobs" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=minimal" \
        -d "{
            \"keyword\": \"$keyword\",
            \"status\": \"pending\",
            \"priority\": 1,
            \"max_results\": 50,
            \"created_at\": \"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\"
        }")
    
    if [[ $? -eq 0 ]]; then
        echo "  ✓ Job created successfully"
    else
        echo "  ✗ Failed to create job"
    fi
    
    # Small delay between requests
    sleep 0.5
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] All new jobs created. Now triggering discovery runs..."

# Trigger discovery runs
for i in {1..50}; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Discovery run $i/50"
    
    response=$(curl -s -X POST \
        "https://jecyykhmabcvguvjghll.supabase.co/functions/v1/run-discovery-job" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
        -H "Content-Type: application/json" \
        -d "{}")
    
    echo "$response"
    
    # Get current vendor count
    vendor_count=$(curl -s \
        "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/vendors?select=id" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" | jq length 2>/dev/null || echo "0")
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Current vendor count: $vendor_count"
    
    # Check if we have enough vendors
    if [[ $vendor_count -ge 1000 ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Target reached! Found $vendor_count vendors."
        break
    fi
    
    # Wait between runs
    sleep 2
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Discovery session completed." 