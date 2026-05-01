#!/usr/bin/env bash

readonly LOG_FILE="$1"

# Print table header
printf "%-10s | %-10s | %-11s | %-9s | %-9s | %-15s | %-12s | %-10s\n" \
       "Date" "Mission ID" "Destination" "Status" "Crew Size" "Duration (days)" "Success Rate" "Security Code"
printf "%s\n" "--------------------------------------------------------------------------------------------------------------"

awk -F'|' '
NF == 8 {
    # Clean whitespace
    for(i = 1; i <= NF; i++) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)
    }

    # FORMAT VALIDATION
    # $1 (Date) must be YYYY-MM-DD
    # $5 (Crew Size) must be numeric
    # $6 (Duration (days)) must be numeric
    if ($1 ~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/ && $5 ~ /^[0-9]+$/ && $6 ~ /^[0-9]+$/) {
        # Only include Completed missions in Mars
        if (($4 == "Completed") && $3 == "Mars") {
            printf "%-10s | %-10s | %-11s | %-9s | %-9s | %-15s | %-12s | %-10s\n", $1, $2, $3, $4, $5, $6, $7, $8
        }
    }
}
' "$LOG_FILE" | sort -t '|' -k 6,6nr | head -n 1 # Sort by Duration (days) in descending order, then print the top entry