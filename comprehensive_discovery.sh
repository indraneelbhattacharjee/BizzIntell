#!/bin/bash

# Comprehensive Discovery Script - Searches ALL Google pages for each keyword
# Target: 1000+ unique US vendors across Chiropractic, Optometry, Auto Repair

SUPABASE_URL="https://jecyykhmabcvguvjghll.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplY3l5a2htYWJjdmd1dmpnaGxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxNjE3OTksImV4cCI6MjA2NDczNzc5OX0.ivch89osJxBbvYGQEoMdAweaO-py2VzCzqwtLWWIAcw"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting COMPREHENSIVE discovery - searching ALL Google pages for each keyword"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Target: 1000+ unique US vendors across Chiropractic, Optometry, Auto Repair"

# Create comprehensive jobs with extensive keyword sets for each industry
declare -a job_configs=(
    # Chiropractic - Comprehensive keywords
    '{"job_name": "Chiropractic_Comprehensive_1", "seed_keywords": ["chiropractic software 2024", "chiropractic practice management system", "chiropractic office technology", "chiropractic clinic software", "chiropractic practice solutions", "chiropractic office automation", "chiropractic software reviews", "chiropractic practice technology", "chiropractic clinic management", "chiropractic office solutions"]}'
    '{"job_name": "Chiropractic_Comprehensive_2", "seed_keywords": ["chiropractic EHR software", "chiropractic practice management platform", "chiropractic office management system", "chiropractic clinic management software", "chiropractic practice automation", "chiropractic billing software", "chiropractic scheduling software", "chiropractic patient management", "chiropractic SOAP notes", "chiropractic documentation"]}'
    '{"job_name": "Chiropractic_Comprehensive_3", "seed_keywords": ["chiropractic cloud software", "chiropractic web-based software", "chiropractic practice management tools", "chiropractic office software", "chiropractic clinic management system", "chiropractic business software", "chiropractic practice software", "chiropractic management software", "chiropractic office management", "chiropractic clinic software"]}'
    
    # Optometry - Comprehensive keywords
    '{"job_name": "Optometry_Comprehensive_1", "seed_keywords": ["optometry software 2024", "optometry practice management system", "optometry office technology", "optometry clinic software", "optometry practice solutions", "optometry office automation", "optometry software reviews", "optometry practice technology", "optometry clinic management", "optometry office solutions"]}'
    '{"job_name": "Optometry_Comprehensive_2", "seed_keywords": ["eye care practice management", "optical office software", "optometry practice management platform", "optometry office management system", "optometry clinic management software", "optometry practice automation", "optometry billing software", "optometry scheduling software", "optometry patient management", "optometry documentation"]}'
    '{"job_name": "Optometry_Comprehensive_3", "seed_keywords": ["optometry cloud software", "optometry web-based software", "optometry practice management tools", "optometry office software", "optometry clinic management system", "optometry business software", "optometry practice software", "optometry management software", "optometry office management", "optometry clinic software"]}'
    
    # Auto Repair - Comprehensive keywords
    '{"job_name": "AutoRepair_Comprehensive_1", "seed_keywords": ["auto repair software 2024", "automotive shop management system", "auto repair shop software", "automotive business software", "auto repair shop technology", "automotive shop solutions", "auto repair management software", "automotive shop automation", "auto repair shop systems", "automotive business technology"]}'
    '{"job_name": "AutoRepair_Comprehensive_2", "seed_keywords": ["repair shop management software", "auto shop practice management", "automotive repair shop software", "auto repair practice management", "automotive shop management platform", "auto repair office management", "auto repair billing software", "auto repair scheduling software", "auto repair customer management", "auto repair documentation"]}'
    '{"job_name": "AutoRepair_Comprehensive_3", "seed_keywords": ["auto repair cloud software", "auto repair web-based software", "auto repair practice management tools", "auto repair office software", "auto repair shop management system", "auto repair business software", "auto repair practice software", "auto repair management software", "auto repair office management", "auto repair shop software"]}'
    
    # Additional specialized keywords
    '{"job_name": "Specialized_Healthcare_1", "seed_keywords": ["healthcare practice management software", "medical office software", "clinical practice management", "healthcare business software", "medical practice automation", "healthcare office management", "medical clinic software", "healthcare practice solutions", "medical office automation", "healthcare practice technology"]}'
    '{"job_name": "Specialized_Healthcare_2", "seed_keywords": ["practice management EHR", "medical practice management system", "healthcare practice management platform", "medical office management system", "healthcare clinic management software", "medical practice automation", "healthcare billing software", "medical scheduling software", "healthcare patient management", "medical documentation software"]}'
)

# Create jobs for each configuration
for job_config in "${job_configs[@]}"; do
    job_name=$(echo "$job_config" | jq -r '.job_name')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating comprehensive job: $job_name"
    
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
        echo "  ✓ Comprehensive job created successfully"
    else
        echo "  ✗ Failed to create comprehensive job"
    fi
    
    # Small delay between requests
    sleep 0.5
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] All comprehensive jobs created. Now running discovery with FULL pagination..."

# Run discovery continuously until target is reached
run_count=0
max_runs=500  # Safety limit

while [ $run_count -lt $max_runs ]; do
    run_count=$((run_count + 1))
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ===== DISCOVERY RUN $run_count ====="
    
    # Trigger discovery run
    response=$(curl -s -X POST \
        "https://jecyykhmabcvguvjghll.supabase.co/functions/v1/run-discovery-job" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
        -H "Content-Type: application/json" \
        -d "{}")
    
    echo "Response: $response"
    
    # Get current vendor count
    vendor_count=$(curl -s \
        "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/vendors?select=id" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" | jq length 2>/dev/null || echo "0")
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Current vendor count: $vendor_count"
    
    # Check if we have enough vendors
    if [[ $vendor_count -ge 1000 ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🎉 TARGET REACHED! Found $vendor_count vendors."
        break
    fi
    
    # Check if there are any pending jobs
    pending_jobs=$(curl -s \
        "https://jecyykhmabcvguvjghll.supabase.co/rest/v1/bulk_discovery_jobs?select=id&status=eq.pending" \
        -H "apikey: $SUPABASE_ANON_KEY" \
        -H "Authorization: Bearer $SUPABASE_ANON_KEY" | jq length 2>/dev/null || echo "0")
    
    if [[ $pending_jobs -eq 0 ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No more pending jobs. Creating additional jobs..."
        
        # Create more jobs with different keyword variations
        additional_keywords=(
            "chiropractic software company"
            "optometry software company" 
            "auto repair software company"
            "chiropractic practice management company"
            "optometry practice management company"
            "auto repair shop management company"
            "chiropractic EHR company"
            "optometry EHR company"
            "auto repair business software company"
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
    
    # Wait between runs to allow processing
    sleep 3
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Comprehensive discovery session completed."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Final vendor count: $vendor_count" 