#!/bin/bash

set -euo pipefail

domain=$1

# Check if domain parameter is provided
if [[ -z "$domain" ]]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Function to print log messages
log() {
    echo "[+] $1"
}

# Check if all required tools are installed
check_tools() {
    local tools=(subfinder assetfinder findomain amass httpx waymore katana nuclei ffuf qsreplace parallel curl)
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "[ERROR] Tool $tool is not installed or not in PATH."
            exit 1
        fi
    done
}

# Passive domain enumeration and data gathering
domain_enum() {
    log "Starting domain enumeration for: $domain"

    mkdir -p "$domain/sources" "$domain/Recon/nuclei"

    # Run subdomain enumeration tools
    log "Running subfinder..."
    subfinder -d "$domain" -o "$domain/sources/subfinder.txt"

    log "Running assetfinder..."
    assetfinder --subs-only "$domain" | tee "$domain/sources/assetfinder.txt"

    log "Running findomain..."
    findomain -t "$domain" -q | tee "$domain/sources/findomain.txt"

    log "Running amass..."
    amass enum -d "$domain" -o "$domain/sources/amass.txt"

    # Merge and deduplicate subdomain results
    log "Merging and deduplicating subdomains..."
    sort -u "$domain/sources/"*.txt > "$domain/sources/all.txt"

    # Check which domains are live
    log "Checking live domains with httpx..."
    httpx -silent -l "$domain/sources/all.txt" -o "$domain/sources/live_domains.txt"

    # Crawl URLs with waymore and katana
    log "Running waymore..."
    waymore -i "$domain" -mode U -oU "$domain/sources/waymore.txt"

    log "Running katana..."
    katana -list "$domain/sources/live_domains.txt" -f qurl -silent -kf all -jc -aff -d 5 -o "$domain/sources/katana-param.txt"

    # Extract interesting files from crawled URLs
    log "Extracting interesting files..."
    grep -E -i -o '\S+\.(bak|backup|swp|old|db|sql|asp|aspx|py|rb|php|cache|cgi|conf|csv|html|inc|jar|js|json|jsp|lock|log|tar\.gz|bz2|zip|txt|wadl|xml)' \
        "$domain/sources/waymore.txt" "$domain/sources/katana-param.txt" | sort -u > "$domain/sources/interesting_files.txt"

    # Extract URLs with parameters for fuzzing
    log "Extracting URLs with parameters..."
    cat "$domain/sources/waymore.txt" "$domain/sources/katana-param.txt" | sort -u | grep "=" | qsreplace 'FUZZ' | \
        egrep -v '(.css|.png|blog|utm_source|utm_medium|utm_campaign)' > "$domain/sources/waymore-katana-unfilter-urls.txt"

    # Filter live URLs with parameters
    log "Filtering live URLs with parameters using httpx..."
    httpx -silent -t 150 -rl 150 -l "$domain/sources/waymore-katana-unfilter-urls.txt" -o "$domain/sources/waymore-katana-filter-urls.txt"
    grep '=' "$domain/sources/waymore-katana-filter-urls.txt" > "$domain/sources/parameters_with_equal.txt"
}

# Vulnerability scanning using nuclei and fuzzing with ffuf
scanner() {
    log "Starting nuclei scan for: $domain"

    # Update nuclei templates before scanning
    nuclei -update-templates

    log "Running nuclei for fuzzing templates..."
    nuclei -t /home/kali/fuzzing-templates/ -l "$domain/sources/parameters_with_equal.txt" -c 50 -o "$domain/Recon/nuclei/fuzzing-results.txt"

    log "Running nuclei for live domains..."
    nuclei -l "$domain/sources/live_domains.txt" -c 50 -o "$domain/sources/vulnerability.txt"

    log "Running directory fuzzing with ffuf..."
    ffuf -w "$domain/sources/parameters_with_equal.txt" -u "https://$domain/FUZZ" -o "$domain/Recon/ffuf-results.txt"
}

# Send URLs to Burp Suite proxy for manual or automated testing
send_to_burp() {
    log "Sending data to Burp Suite for further testing..."

    # Check if Burp Suite proxy is running
    if nc -zv 127.0.0.1 8080 &> /dev/null; then
        cat "$domain/sources/parameters_with_equal.txt" "$domain/sources/waymore-katana-unfilter-urls.txt" "$domain/sources/waymore-katana-filter-urls.txt" | \
        parallel -j 10 'curl --proxy http://127.0.0.1:8080 -sk {}' > /dev/null
    else
        echo "[WARN] Burp Suite proxy is not running on 127.0.0.1:8080. Skipping sending data."
    fi
}

# Main function to orchestrate the steps
main() {
    check_tools
    domain_enum
    scanner
    send_to_burp
    log "Recon and scanning completed for: $domain"
}

main
