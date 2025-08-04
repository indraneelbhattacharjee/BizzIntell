#!/bin/bash

# Massive Discovery Script - Uses debug version without restrictive filters
# Target: 1000+ vendors across Chiropractic, Optometry, Auto Repair

SUPABASE_URL="https://jecyykhmabcvguvjghll.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplY3l5a2htYWJjdmd1dmpnaGxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxNjE3OTksImV4cCI6MjA2NDczNzc5OX0.ivch89osJxBbvYGQEoMdAweaO-py2VzCzqwtLWWIAcw"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting MASSIVE discovery campaign for 1000+ vendors"

# Create extensive job configurations with diverse keywords
declare -a job_configs=(
    # Chiropractic - Extensive variations
    '{"job_name": "Chiro_Massive_1", "seed_keywords": ["chiropractic software", "chiropractic practice management", "chiropractic office software", "chiropractic clinic software", "chiropractic business software"]}'
    '{"job_name": "Chiro_Massive_2", "seed_keywords": ["chiropractic office management", "chiropractic practice systems", "chiropractic clinic management", "chiropractic office automation", "chiropractic practice technology"]}'
    '{"job_name": "Chiro_Massive_3", "seed_keywords": ["chiropractic software reviews", "chiropractic practice solutions", "chiropractic office solutions", "chiropractic clinic solutions", "chiropractic business solutions"]}'
    '{"job_name": "Chiro_Massive_4", "seed_keywords": ["chiropractic EHR software", "chiropractic EMR software", "chiropractic practice management platform", "chiropractic office management system", "chiropractic clinic management software"]}'
    '{"job_name": "Chiro_Massive_5", "seed_keywords": ["chiropractic practice automation", "chiropractic office technology", "chiropractic clinic technology", "chiropractic business technology", "chiropractic practice software"]}'
    
    # Optometry - Extensive variations
    '{"job_name": "Opto_Massive_1", "seed_keywords": ["optometry software", "optometry practice management", "optometry office software", "optometry clinic software", "optometry business software"]}'
    '{"job_name": "Opto_Massive_2", "seed_keywords": ["optometry office management", "optometry practice systems", "optometry clinic management", "optometry office automation", "optometry practice technology"]}'
    '{"job_name": "Opto_Massive_3", "seed_keywords": ["optometry software reviews", "optometry practice solutions", "optometry office solutions", "optometry clinic solutions", "optometry business solutions"]}'
    '{"job_name": "Opto_Massive_4", "seed_keywords": ["eye care practice management", "optical office software", "optometry practice management platform", "optometry office management system", "optometry clinic management software"]}'
    '{"job_name": "Opto_Massive_5", "seed_keywords": ["optometry practice automation", "optometry office technology", "optometry clinic technology", "optometry business technology", "optometry practice software"]}'
    
    # Auto Repair - Extensive variations
    '{"job_name": "Auto_Massive_1", "seed_keywords": ["auto repair software", "auto repair practice management", "auto repair office software", "auto repair shop software", "auto repair business software"]}'
    '{"job_name": "Auto_Massive_2", "seed_keywords": ["auto repair office management", "auto repair practice systems", "auto repair shop management", "auto repair office automation", "auto repair practice technology"]}'
    '{"job_name": "Auto_Massive_3", "seed_keywords": ["auto repair software reviews", "auto repair practice solutions", "auto repair office solutions", "auto repair shop solutions", "auto repair business solutions"]}'
    '{"job_name": "Auto_Massive_4", "seed_keywords": ["automotive shop management", "automotive office software", "auto repair practice management platform", "auto repair office management system", "auto repair shop management software"]}'
    '{"job_name": "Auto_Massive_5", "seed_keywords": ["auto repair practice automation", "auto repair office technology", "auto repair shop technology", "auto repair business technology", "auto repair practice software"]}'
    
    # Additional variations
    '{"job_name": "Chiro_Massive_6", "seed_keywords": ["chiropractic management software", "chiropractic scheduling software", "chiropractic billing software", "chiropractic patient management", "chiropractic documentation software"]}'
    '{"job_name": "Opto_Massive_6", "seed_keywords": ["optometry management software", "optometry scheduling software", "optometry billing software", "optometry patient management", "optometry documentation software"]}'
    '{"job_name": "Auto_Massive_6", "seed_keywords": ["auto repair management software", "auto repair scheduling software", "auto repair billing software", "auto repair customer management", "auto repair documentation software"]}'
    
    # Industry-specific terms
    '{"job_name": "Chiro_Massive_7", "seed_keywords": ["chiropractic SOAP notes", "chiropractic treatment plans", "chiropractic patient records", "chiropractic insurance billing", "chiropractic appointment scheduling"]}'
    '{"job_name": "Opto_Massive_7", "seed_keywords": ["optometry patient records", "optometry insurance billing", "optometry appointment scheduling", "optometry vision testing", "optometry contact lens management"]}'
    '{"job_name": "Auto_Massive_7", "seed_keywords": ["auto repair work orders", "auto repair customer records", "auto repair parts management", "auto repair inventory software", "auto repair service history"]}'
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

echo "[$(date '+%Y-%m-%d %H:%M:%S')] All jobs created. Starting massive discovery runs..."

# Get initial vendor count
initial_count=$(curl -s \
    "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/vendors?select=id" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Authorization: Bearer $SUPABASE_ANON_KEY" | jq length 2>/dev/null || echo "0")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Initial vendor count: $initial_count"

# Trigger discovery runs continuously
run_count=0
max_runs=200  # Increased for massive discovery

while [[ $run_count -lt $max_runs ]]; do
    run_count=$((run_count + 1))
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Discovery run $run_count/$max_runs"
    
    response=$(curl -s -X POST \
        "https://jecyykhmabcvguvjghll.supabase.co/functions/v1/run-discovery-job" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
        -H "Content-Type: application/json" \
        -d "{}")
    
    echo "$response"
    
    # Get current vendor count
    current_count=$(curl -s \
        "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/vendors?select=id" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" | jq length 2>/dev/null || echo "0")
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Current vendor count: $current_count"
    
    # Calculate progress
    vendors_added=$((current_count - initial_count))
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Total vendors added this session: $vendors_added"
    
    # Check if we have enough vendors
    if [[ $current_count -ge 1000 ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🎉 TARGET REACHED! Found $current_count vendors!"
        break
    fi
    
    # Check if no more pending jobs
    if [[ "$response" == *"No pending jobs"* ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No more pending jobs. Creating additional jobs..."
        
        # Create more jobs with different keywords
        additional_keywords=(
            "chiropractic software 2024" "optometry software 2024" "auto repair software 2024"
            "chiropractic practice management 2024" "optometry practice management 2024" "auto repair practice management 2024"
            "chiropractic office software 2024" "optometry office software 2024" "auto repair office software 2024"
        )
        
        for keyword in "${additional_keywords[@]}"; do
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating additional job for: $keyword"
            curl -s -X POST \
                "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/bulk_discovery_jobs" \
                -H "apikey: $SUPABASE_ANON_KEY" \
                -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
                -H "Content-Type: application/json" \
                -H "Prefer: return=minimal" \
                -d "{
                    \"job_name\": \"Additional_$(date +%s)\",
                    \"seed_keywords\": [\"$keyword\"],
                    \"status\": \"pending\",
                    \"current_keyword_index\": 0,
                    \"vendors_found\": 0,
                    \"created_at\": \"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\"
                }"
            sleep 0.5
        done
    fi
    
    # Wait between runs
    sleep 3
done

# Final status
final_count=$(curl -s \
    "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/vendors?select=id" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Authorization: Bearer $SUPABASE_ANON_KEY" | jq length 2>/dev/null || echo "0")

total_added=$((final_count - initial_count))

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🏁 MASSIVE DISCOVERY COMPLETED!"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Final vendor count: $final_count"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Total vendors added: $total_added"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Discovery runs completed: $run_count" 