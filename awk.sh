#!/usr/bin/awk -f
BEGIN { 
    FS = "|"
    max_duration = 0
}
    
    # Skip empty lines, comments, and system lines
    /^#/ || /^[ \t]*$/ || /SYSTEM:/ || /CONFIG:/ || /CHECKSUM:/ { 
        next 
    }
    
    # Process valid data lines
    NF == 8 {
        # Trim whitespace from fields
        for (i = 1; i <= NF; i++) {
            gsub(/^[ \t]+|[ \t]+$/, "", $i)
        }
        
        # Check if it's a completed Mars mission
        if (tolower($3) == "mars" && tolower($4) == "completed") {
            # Extract duration (field 6) and convert to number
            duration = $6 + 0
            
            # Check if duration is a valid number and is the longest so far
            if (duration ~ /^[0-9]+$/ && duration > max_duration) {
                max_duration = duration
                date = $1
                mission_id = $2
                destination = $3
                status = $4
                crew_size = $5
                success_rate = $7
                security_code = $8
            }
        }
    }
    
    END {
        if (max_duration > 0) {
            print "╔══════════════════════════════════════════════════════════════╗"
            print "║       LONGEST SUCCESSFUL MARS MISSION FOUND                  ║"
            print "╠══════════════════════════════════════════════════════════════╣"
            printf "║ Date:          %-45s ║\n", date
            printf "║ Mission ID:    %-45s ║\n", mission_id
            printf "║ Destination:   %-45s ║\n", destination
            printf "║ Status:        %-45s ║\n", status
            printf "║ Crew Size:     %-45s ║\n", crew_size
            printf "║ Duration:      %-45s ║\n", max_duration " days"
            printf "║ Success Rate:  %-45s ║\n", success_rate "%"
            print "╠══════════════════════════════════════════════════════════════╣"
            printf "║ SECURITY CODE: %-45s ║\n", security_code
            print "╚══════════════════════════════════════════════════════════════╝"
            print ""
            print "Answer: " security_code
        } else {
            print "No completed Mars missions found in the log file."
        }
    }