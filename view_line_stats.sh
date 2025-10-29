#!/bin/bash

################################################################################
# VIEW LINE COUNT STATISTICS (Enhanced Version)
################################################################################
#
# This script displays line count statistics with enhanced capabilities:
#   - Daily, weekly, and date range queries
#   - Separate code vs document statistics
#   - Major edits (>50%) tracking
#   - JSON stats aggregation
#
# Usage:
#   bash view_line_stats.sh [options]
#
# Options:
#   today                    - Show today's changes only
#   week                     - Show last 7 days
#   YYYY-MM-DD YYYY-MM-DD   - Show date range
#   all                      - Show all-time statistics (default)
#   log                      - Show the markdown log
#
# Examples:
#   bash view_line_stats.sh today
#   bash view_line_stats.sh week
#   bash view_line_stats.sh 2025-10-24 2025-11-02
#
################################################################################

ALL_PATTERN="\.(py|md|sh|txt|pdf)$"

# Function to aggregate JSON stats for a date range
aggregate_stats() {
    local start_date="$1"
    local end_date="$2"
    local pattern="$3"

    total_lines=0
    code_lines=0
    docs_lines=0
    new_lines=0
    modified_lines=0
    major_edits=0

    # Find and process JSON stats files
    for json_file in LINE_COUNT_STATS.json.*; do
        if [ -f "$json_file" ]; then
            file_date=$(echo "$json_file" | sed 's/LINE_COUNT_STATS.json.//')

            # Check if date is in range
            if [[ "$file_date" >= "$start_date" ]] && [[ "$file_date" <= "$end_date" ]]; then
                # Extract values from JSON (simple parsing)
                total=$(grep '"total_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                code=$(grep '"code_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                docs=$(grep '"docs_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                new=$(grep '"new_files_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                modified=$(grep '"modified_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                major=$(grep '"major_edits":' "$json_file" | awk '{print $2}' | tr -d ',')

                total_lines=$((total_lines + total))
                code_lines=$((code_lines + code))
                docs_lines=$((docs_lines + docs))
                new_lines=$((new_lines + new))
                modified_lines=$((modified_lines + modified))
                major_edits=$((major_edits + major))
            fi
        fi
    done

    echo "$total_lines|$code_lines|$docs_lines|$new_lines|$modified_lines|$major_edits"
}

# Parse arguments
OPTION="${1:-all}"
START_DATE="${2:-}"

echo "================================================================"
echo "LINE COUNT STATISTICS"
echo "================================================================"
echo ""

case "$OPTION" in
    today)
        echo "Today's statistics:"
        echo ""

        TODAY=$(date +"%Y-%m-%d")

        # Try JSON file first
        JSON_FILE="LINE_COUNT_STATS.json.${TODAY}"
        if [ -f "$JSON_FILE" ]; then
            echo "Date: $TODAY"
            echo ""

            total=$(grep '"total_lines":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            code=$(grep '"code_lines":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            docs=$(grep '"docs_lines":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            new=$(grep '"new_files_lines":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            new_code=$(grep '"new_files_code":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            new_docs=$(grep '"new_files_docs":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            modified=$(grep '"modified_lines":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            modified_code=$(grep '"modified_code":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            modified_docs=$(grep '"modified_docs":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            major=$(grep '"major_edits":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            major_code=$(grep '"major_edits_code":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')
            major_docs=$(grep '"major_edits_docs":' "$JSON_FILE" | awk '{print $2}' | tr -d ',')

            echo "TOTAL: $total lines"
            echo "  Code (.py, .sh):           $code lines"
            echo "  Documents (.md, .txt, .pdf): $docs lines"
            echo ""
            echo "Breakdown:"
            echo "  New files:                 $new lines"
            echo "    - Code:                  $new_code lines"
            echo "    - Documents:             $new_docs lines"
            echo "  Modifications:             $modified lines"
            echo "    - Code:                  $modified_code lines"
            echo "    - Documents:             $modified_docs lines"
            if [ "$major" -gt 0 ]; then
                echo "  Major edits (>50%):        $major files"
                echo "    - Code:                  $major_code files"
                echo "    - Documents:             $major_docs files"
            fi
        else
            echo "No statistics found for today."
            echo ""
            echo "Run: bash daily_line_count.sh"
        fi
        ;;

    week)
        echo "Last 7 days summary:"
        echo ""

        START_DATE=$(date -d "7 days ago" +"%Y-%m-%d" 2>/dev/null || date -v-7d +"%Y-%m-%d")
        END_DATE=$(date +"%Y-%m-%d")

        # Aggregate stats
        stats=$(aggregate_stats "$START_DATE" "$END_DATE")
        IFS='|' read -r total code docs new modified major <<< "$stats"

        echo "Date range: $START_DATE to $END_DATE"
        echo ""
        echo "TOTAL: $total lines"
        echo "  Code (.py, .sh):           $code lines"
        echo "  Documents (.md, .txt, .pdf): $docs lines"
        echo ""
        echo "Breakdown:"
        echo "  New files:                 $new lines"
        echo "  Modifications:             $modified lines"
        echo "  Major edits (>50%):        $major files"
        echo ""

        # Show daily breakdown
        echo "Daily breakdown:"
        echo "----------------"
        for json_file in LINE_COUNT_STATS.json.*; do
            if [ -f "$json_file" ]; then
                file_date=$(echo "$json_file" | sed 's/LINE_COUNT_STATS.json.//')
                if [[ "$file_date" >= "$START_DATE" ]] && [[ "$file_date" <= "$END_DATE" ]]; then
                    total=$(grep '"total_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                    code=$(grep '"code_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                    docs=$(grep '"docs_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                    printf "%s: %5d lines (Code: %5d, Docs: %5d)\n" "$file_date" "$total" "$code" "$docs"
                fi
            fi
        done
        ;;

    log)
        if [ -f "LINE_COUNT_LOG.md" ]; then
            cat LINE_COUNT_LOG.md
        else
            echo "No log file found. Run daily_line_count.sh to create it."
        fi
        ;;

    all)
        echo "All-time statistics:"
        echo ""

        if [ -d .git ]; then
            # Total commits
            TOTAL_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo 0)

            echo "Total commits: $TOTAL_COMMITS"
            echo ""

            # Lines by file type
            echo "Current lines by file type:"
            echo ""

            # Code files
            code_total=0
            for ext in py sh; do
                files=$(git ls-files "*.$ext" 2>/dev/null)
                if [ -n "$files" ]; then
                    total=$(echo "$files" | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
                    count=$(echo "$files" | wc -l)
                    printf "  %-8s: %8s lines across %3s files\n" ".$ext" "$total" "$count"
                    code_total=$((code_total + total))
                fi
            done
            printf "  %-8s: %8s lines total\n" "Code" "$code_total"

            echo ""

            # Document files
            docs_total=0
            for ext in md txt pdf; do
                files=$(git ls-files "*.$ext" 2>/dev/null)
                if [ -n "$files" ]; then
                    if [ "$ext" = "pdf" ]; then
                        count=$(echo "$files" | wc -l)
                        printf "  %-8s: %8s files\n" ".$ext" "$count"
                    else
                        total=$(echo "$files" | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
                        count=$(echo "$files" | wc -l)
                        printf "  %-8s: %8s lines across %3s files\n" ".$ext" "$total" "$count"
                        docs_total=$((docs_total + total))
                    fi
                fi
            done
            printf "  %-8s: %8s lines total\n" "Docs" "$docs_total"

            echo ""
            echo "  ----------------------------------------"
            printf "  %-8s: %8s lines\n" "TOTAL" "$((code_total + docs_total))"
            echo ""

            # Aggregate all JSON stats if available
            if ls LINE_COUNT_STATS.json.* 1> /dev/null 2>&1; then
                echo "Historical generation statistics:"
                echo ""

                # Get earliest and latest dates
                first_date=$(ls LINE_COUNT_STATS.json.* | head -1 | sed 's/LINE_COUNT_STATS.json.//')
                last_date=$(ls LINE_COUNT_STATS.json.* | tail -1 | sed 's/LINE_COUNT_STATS.json.//')

                stats=$(aggregate_stats "$first_date" "$last_date")
                IFS='|' read -r total code docs new modified major <<< "$stats"

                echo "Total lines generated: $total"
                echo "  Code:                $code lines"
                echo "  Documents:           $docs lines"
                echo ""
                echo "Breakdown:"
                echo "  New files:           $new lines"
                echo "  Modifications:       $modified lines"
                echo "  Major edits (>50%):  $major files"
                echo ""
            fi

            # Commit history summary
            echo "Recent commits (last 10):"
            echo ""
            git log --oneline -10 | while read line; do
                echo "  $line"
            done
            echo ""

        else
            echo "Not a Git repository. Run daily_line_count.sh to initialize."
        fi
        ;;

    *)
        # Check if it's a date range (2 date arguments)
        if [ -n "$START_DATE" ]; then
            END_DATE="$OPTION"

            echo "Date range: $START_DATE to $END_DATE"
            echo ""

            # Aggregate stats for date range
            stats=$(aggregate_stats "$START_DATE" "$END_DATE")
            IFS='|' read -r total code docs new modified major <<< "$stats"

            if [ "$total" -eq 0 ]; then
                echo "No statistics found for this date range."
                echo ""
                echo "Available dates:"
                ls LINE_COUNT_STATS.json.* 2>/dev/null | sed 's/LINE_COUNT_STATS.json.//'
            else
                echo "TOTAL: $total lines"
                echo "  Code (.py, .sh):           $code lines"
                echo "  Documents (.md, .txt, .pdf): $docs lines"
                echo ""
                echo "Breakdown:"
                echo "  New files:                 $new lines"
                echo "  Modifications:             $modified lines"
                echo "  Major edits (>50%):        $major files"
                echo ""

                # Show daily breakdown
                echo "Daily breakdown:"
                echo "----------------"
                for json_file in LINE_COUNT_STATS.json.*; do
                    if [ -f "$json_file" ]; then
                        file_date=$(echo "$json_file" | sed 's/LINE_COUNT_STATS.json.//')
                        if [[ "$file_date" >= "$START_DATE" ]] && [[ "$file_date" <= "$END_DATE" ]]; then
                            day_total=$(grep '"total_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                            day_code=$(grep '"code_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                            day_docs=$(grep '"docs_lines":' "$json_file" | awk '{print $2}' | tr -d ',')
                            day_major=$(grep '"major_edits":' "$json_file" | awk '{print $2}' | tr -d ',')
                            printf "%s: %5d lines (Code: %5d, Docs: %5d, Major: %2d)\n" \
                                "$file_date" "$day_total" "$day_code" "$day_docs" "$day_major"
                        fi
                    fi
                done
            fi
        else
            echo "Invalid option or date format."
            echo ""
            echo "Usage: bash view_line_stats.sh [option]"
            echo ""
            echo "Options:"
            echo "  today                     - Today's statistics"
            echo "  week                      - Last 7 days"
            echo "  YYYY-MM-DD YYYY-MM-DD    - Custom date range"
            echo "  all                       - All-time statistics"
            echo "  log                       - View markdown log"
            echo ""
            echo "Examples:"
            echo "  bash view_line_stats.sh today"
            echo "  bash view_line_stats.sh week"
            echo "  bash view_line_stats.sh 2025-10-24 2025-11-02"
            exit 1
        fi
        ;;
esac

echo ""
echo "================================================================"
echo ""
echo "Quick commands:"
echo "  bash view_line_stats.sh today              # Today only"
echo "  bash view_line_stats.sh week               # Last 7 days"
echo "  bash view_line_stats.sh 2025-10-24 2025-11-02  # Date range"
echo "  bash view_line_stats.sh all                # All time"
echo "  bash view_line_stats.sh log                # View log file"
echo ""
