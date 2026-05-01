#!/usr/bin/env bash

readonly LOG_FILE="$1"

echo "Mission: $LOG_FILE"

# Print table header
printf "%-12s | %-10s | %-15s | %-15s | %-9s | %-15s | %-12s | %-15s\n" \
       "Date" "Mission ID" "Destination" "Status" "Crew Size" "Duration (days)" "Success Rate" "Security Code"
printf "%s\n" "--------------------------------------------------------------------------------------------------------------------------"

awk -F'|' '
NF == 8 {
    # Clean whitespace
    for(i = 1; i <= NF; i++) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)
    }

    # FORMAT VALIDATION: 
    # $1 (Date) must be YYYY-MM-DD
    # $5 (Crew Size) must be numeric
    # $6 (Duration (days)) must be numeric
    # This prevents headers or corrupted text from being parsed
    if ($1 ~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/ && $5 ~ /^[0-9]+$/ && $6 ~ /^[0-9]+$/) {
        
        # FILTERING:
        # Example filter: Only include missions with a Success Rate ($7) >= 50.0
        # You can easily change this to check for Status, e.g., if ($4 == "In Progress")
        if (($7 + 0) >= 50.0) {
            # Print the sanitized and formatted row
            printf "%-12s | %-10s | %-15s | %-15s | %-9s | %-15s | %-12s | %-15s\n", $1, $2, $3, $4, $5, $6, $7, $8
        }
    }
}' "$LOG_FILE" | sort -t '|' -k 1,1