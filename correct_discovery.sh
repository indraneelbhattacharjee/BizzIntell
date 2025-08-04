#!/bin/bash

# Correct Discovery Script - Creates new jobs with proper target industries
# Target industries: Chiropractic, Optometry, Auto Repair

SUPABASE_URL="https://jecyykhmabcvguvjghll.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplY3l5a2htYWJjdmd1dmpnaGxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxNjE3OTksImV4cCI6MjA2NDczNzc5OX0.ivch89osJxBbvYGQEoMdAweaO-py2VzCzqwtLWWIAcw"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating new discovery jobs for target industries: Chiropractic, Optometry, Auto Repair"

# Create jobs with proper seed_keywords arrays for each industry
declare -a job_configs=(
    # Chiropractic jobs
    '{"job_name": "Chiropractic_Discovery_1", "seed_keywords": ["chiropractic software 2024", "chiropractic practice management system", "chiropractic office technology", "chiropractic clinic software", "chiropractic practice solutions"]}'
    '{"job_name": "Chiropractic_Discovery_2", "seed_keywords": ["chiropractic office automation", "chiropractic software reviews", "chiropractic practice technology", "chiropractic clinic management", "chiropractic office solutions"]}'
    '{"job_name": "Chiropractic_Discovery_3", "seed_keywords": ["chiropractic EHR software", "chiropractic practice management platform", "chiropractic office management system", "chiropractic clinic management software", "chiropractic practice automation"]}'
    
    # Optometry jobs
    '{"job_name": "Optometry_Discovery_1", "seed_keywords": ["optometry software 2024", "optometry practice management system", "optometry office technology", "optometry clinic software", "optometry practice solutions"]}'
    '{"job_name": "Optometry_Discovery_2", "seed_keywords": ["optometry office automation", "optometry software reviews", "optometry practice technology", "optometry clinic management", "optometry office solutions"]}'
    '{"job_name": "Optometry_Discovery_3", "seed_keywords": ["eye care practice management", "optical office software", "optometry practice management platform", "optometry office management system", "optometry clinic management software"]}'
    
    # Auto Repair jobs
    '{"job_name": "AutoRepair_Discovery_1", "seed_keywords": ["auto repair software 2024", "automotive shop management system", "auto repair shop software", "automotive business software", "auto repair shop technology"]}'
    '{"job_name": "AutoRepair_Discovery_2", "seed_keywords": ["automotive shop solutions", "auto repair management software", "automotive shop automation", "auto repair shop systems", "automotive business technology"]}'
    '{"job_name": "AutoRepair_Discovery_3", "seed_keywords": ["repair shop management software", "auto shop practice management", "automotive repair shop software", "auto repair practice management", "automotive shop management platform"]}'
)

# Create jobs for each configuration
for job_config in "${job_configs[@]}"; do
    job_name=$(echo "$job_config" | jq -r '.job_name')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating job: $job_name"
    
    response=$(curl -s -X POST \
        "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/bulk_discovery_jobs" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=minimal" \
        -d "{
            \"job_name\": \"$job_name\",
            \"seed_keywords\": $(echo "$job_config" | jq -c '.seed_keywords'),
            \"status\": \"pending\",
            \"current_keyword_index\": 0,
            \"vendors_found\": 0,
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
for i in {1..100}; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Discovery run $i/100"
    
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