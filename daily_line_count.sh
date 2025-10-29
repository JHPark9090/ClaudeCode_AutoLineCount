#!/bin/bash

################################################################################
# DAILY LINE COUNT TRACKER (Enhanced Version)
################################################################################
#
# This script tracks lines generated daily with enhanced rules:
#   1. Each file creation counts all lines
#   2. Each edit counts only lines changed
#   3. Multiple edits counted separately
#   4. If >50% edited, counts as new file + edited lines
#   5. Comments and blank lines included
#   6. All file types: .py, .md, .sh, .txt, .pdf
#   7. Separate counts for code vs documents
#
# Usage:
#   bash daily_line_count.sh [optional commit message]
#
################################################################################

DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_FILE="LINE_COUNT_LOG.md"
STATS_FILE="LINE_COUNT_STATS.json"

echo "================================================================"
echo "Daily Line Count - $TIMESTAMP"
echo "================================================================"

# Check if git repo is initialized
if [ ! -d .git ]; then
    echo "Initializing Git repository..."
    git init
    git config user.email "claude-code@example.com"
    git config user.name "Claude Code Assistant"

    # Create .gitignore to exclude common unnecessary files
    if [ ! -f .gitignore ]; then
        echo "Creating .gitignore to exclude unnecessary files..."
        cat > .gitignore << 'GITIGNORE_EOF'
# Line Counting System - Auto-generated .gitignore

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
venv/
env/
ENV/

# Jupyter
.ipynb_checkpoints/
*.ipynb

# Data files (uncomment if you want to track them)
# *.csv
# *.h5
# *.hdf5
# *.npy
# *.npz

# Large data directories
data/
datasets/
checkpoints/
logs/
output/
results/
*.log

# Conda environments
conda-cache/
conda-envs/
anaconda/
miniconda/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Compiled files
*.o
*.a
*.out
*.exe

# System files
Thumbs.db
.Spotlight-V100
.Trashes

# Add your custom exclusions below this line
# (Files above will be ignored for line counting)

GITIGNORE_EOF
        echo "✓ Created .gitignore"
    fi

    echo ""
fi

# Initialize counters
NEW_LINES=0
NEW_LINES_CODE=0
NEW_LINES_DOCS=0
MODIFIED_LINES=0
MODIFIED_LINES_CODE=0
MODIFIED_LINES_DOCS=0
MAJOR_EDITS=0  # Files with >50% changed
MAJOR_EDITS_CODE=0
MAJOR_EDITS_DOCS=0

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "Found uncommitted changes. Analyzing..."
    echo ""

    # File type patterns
    CODE_PATTERN="\.(py|sh)$"
    DOCS_PATTERN="\.(md|txt|pdf)$"
    ALL_PATTERN="\.(py|md|sh|txt|pdf)$"

    # Function to determine file category
    categorize_file() {
        local file="$1"
        if [[ $file =~ \.py$ ]] || [[ $file =~ \.sh$ ]]; then
            echo "code"
        elif [[ $file =~ \.md$ ]] || [[ $file =~ \.txt$ ]] || [[ $file =~ \.pdf$ ]]; then
            echo "docs"
        else
            echo "other"
        fi
    }

    ###########################################################################
    # RULE 1: Count all lines in new files
    ###########################################################################
    NEW_FILES=$(git ls-files --others --exclude-standard | grep -E "$ALL_PATTERN")

    if [ -n "$NEW_FILES" ]; then
        echo "New files created:"
        while IFS= read -r file; do
            if [ -f "$file" ]; then
                lines=$(wc -l < "$file" 2>/dev/null || echo 0)
                category=$(categorize_file "$file")

                echo "  $file: $lines lines [$category]"
                NEW_LINES=$((NEW_LINES + lines))

                if [ "$category" = "code" ]; then
                    NEW_LINES_CODE=$((NEW_LINES_CODE + lines))
                elif [ "$category" = "docs" ]; then
                    NEW_LINES_DOCS=$((NEW_LINES_DOCS + lines))
                fi
            fi
        done <<< "$NEW_FILES"
        echo "Total new file lines: $NEW_LINES (Code: $NEW_LINES_CODE, Docs: $NEW_LINES_DOCS)"
        echo ""
    fi

    ###########################################################################
    # RULES 2, 3, 4: Count modified lines + check 50% rule
    ###########################################################################
    MODIFIED_FILES=$(git diff --name-only | grep -E "$ALL_PATTERN")

    if [ -n "$MODIFIED_FILES" ]; then
        echo "Modified files:"
        while IFS= read -r file; do
            if [ -f "$file" ]; then
                # Count total lines in file
                total_lines=$(wc -l < "$file" 2>/dev/null || echo 0)

                # Count added lines (excluding diff metadata)
                added=$(git diff --no-ext-diff "$file" | grep -c "^+" || echo 0)
                # Subtract diff header lines
                added=$((added > 0 ? added - 1 : 0))

                # Count removed lines
                removed=$(git diff --no-ext-diff "$file" | grep -c "^-" || echo 0)
                removed=$((removed > 0 ? removed - 1 : 0))

                # Calculate change percentage
                changed_lines=$((added + removed))
                if [ $total_lines -gt 0 ]; then
                    change_pct=$((changed_lines * 100 / total_lines))
                else
                    change_pct=0
                fi

                category=$(categorize_file "$file")

                # RULE 4: Check if >50% changed
                if [ $change_pct -gt 50 ] && [ $added -gt 0 ]; then
                    echo "  $file: +$added lines (${change_pct}% changed - MAJOR EDIT) [$category]"
                    MAJOR_EDITS=$((MAJOR_EDITS + 1))

                    if [ "$category" = "code" ]; then
                        MAJOR_EDITS_CODE=$((MAJOR_EDITS_CODE + 1))
                    elif [ "$category" = "docs" ]; then
                        MAJOR_EDITS_DOCS=$((MAJOR_EDITS_DOCS + 1))
                    fi
                elif [ $added -gt 0 ]; then
                    echo "  $file: +$added lines (${change_pct}% changed) [$category]"
                fi

                if [ $added -gt 0 ]; then
                    MODIFIED_LINES=$((MODIFIED_LINES + added))

                    if [ "$category" = "code" ]; then
                        MODIFIED_LINES_CODE=$((MODIFIED_LINES_CODE + added))
                    elif [ "$category" = "docs" ]; then
                        MODIFIED_LINES_DOCS=$((MODIFIED_LINES_DOCS + added))
                    fi
                fi
            fi
        done <<< "$MODIFIED_FILES"

        echo "Total modified lines: $MODIFIED_LINES (Code: $MODIFIED_LINES_CODE, Docs: $MODIFIED_LINES_DOCS)"
        if [ $MAJOR_EDITS -gt 0 ]; then
            echo "Major edits (>50% changed): $MAJOR_EDITS files (Code: $MAJOR_EDITS_CODE, Docs: $MAJOR_EDITS_DOCS)"
        fi
        echo ""
    fi

    ###########################################################################
    # Calculate totals
    ###########################################################################
    TOTAL_TODAY=$((NEW_LINES + MODIFIED_LINES))
    TOTAL_CODE=$((NEW_LINES_CODE + MODIFIED_LINES_CODE))
    TOTAL_DOCS=$((NEW_LINES_DOCS + MODIFIED_LINES_DOCS))

    # Add major edit files to file count
    TOTAL_FILES_CREATED=$((NEW_LINES > 0 ? 1 : 0))
    TOTAL_FILES_CREATED=$((TOTAL_FILES_CREATED + MAJOR_EDITS))

    echo "================================================================"
    echo "TOTAL LINES GENERATED TODAY: $TOTAL_TODAY"
    echo "  Code (.py, .sh):         $TOTAL_CODE lines"
    echo "  Documents (.md, .txt, .pdf): $TOTAL_DOCS lines"
    echo ""
    echo "Breakdown:"
    echo "  New files:               $NEW_LINES lines"
    echo "    - Code:                $NEW_LINES_CODE lines"
    echo "    - Documents:           $NEW_LINES_DOCS lines"
    echo "  Modifications:           $MODIFIED_LINES lines"
    echo "    - Code:                $MODIFIED_LINES_CODE lines"
    echo "    - Documents:           $MODIFIED_LINES_DOCS lines"
    if [ $MAJOR_EDITS -gt 0 ]; then
        echo ""
        echo "  Major edits (>50%):      $MAJOR_EDITS files count as new"
        echo "    - Code:                $MAJOR_EDITS_CODE files"
        echo "    - Documents:           $MAJOR_EDITS_DOCS files"
    fi
    echo "================================================================"
    echo ""

    ###########################################################################
    # Append to log file
    ###########################################################################
    if [ ! -f "$LOG_FILE" ]; then
        cat > "$LOG_FILE" << 'EOF'
# Daily Line Count Log

This file tracks lines generated each day with enhanced rules.

## Counting Rules

1. ✓ Each file creation counts all lines
2. ✓ Each edit counts only lines changed
3. ✓ Multiple edits counted separately
4. ✓ If >50% edited, counts as new file + edited lines
5. ✓ Comments and blank lines included
6. ✓ All file types: .py, .md, .sh, .txt, .pdf
7. ✓ Separate counts for code vs documents

---

EOF
    fi

    {
        echo "## $DATE"
        echo ""
        echo "**Total: $TOTAL_TODAY lines** (Code: $TOTAL_CODE, Docs: $TOTAL_DOCS)"
        echo ""
        echo "- New files: $NEW_LINES lines (Code: $NEW_LINES_CODE, Docs: $NEW_LINES_DOCS)"
        echo "- Modifications: $MODIFIED_LINES lines (Code: $MODIFIED_LINES_CODE, Docs: $MODIFIED_LINES_DOCS)"
        if [ $MAJOR_EDITS -gt 0 ]; then
            echo "- Major edits (>50%): $MAJOR_EDITS files (Code: $MAJOR_EDITS_CODE, Docs: $MAJOR_EDITS_DOCS)"
        fi
        echo ""
        echo "<details>"
        echo "<summary>Files changed (click to expand)</summary>"
        echo ""
        echo '```'
        git status -s | grep -E "$ALL_PATTERN"
        echo '```'
        echo ""
        echo "</details>"
        echo ""
        echo "---"
        echo ""
    } >> "$LOG_FILE"

    ###########################################################################
    # Save statistics to JSON
    ###########################################################################
    {
        echo "{"
        echo "  \"date\": \"$DATE\","
        echo "  \"timestamp\": \"$TIMESTAMP\","
        echo "  \"total_lines\": $TOTAL_TODAY,"
        echo "  \"code_lines\": $TOTAL_CODE,"
        echo "  \"docs_lines\": $TOTAL_DOCS,"
        echo "  \"new_files_lines\": $NEW_LINES,"
        echo "  \"new_files_code\": $NEW_LINES_CODE,"
        echo "  \"new_files_docs\": $NEW_LINES_DOCS,"
        echo "  \"modified_lines\": $MODIFIED_LINES,"
        echo "  \"modified_code\": $MODIFIED_LINES_CODE,"
        echo "  \"modified_docs\": $MODIFIED_LINES_DOCS,"
        echo "  \"major_edits\": $MAJOR_EDITS,"
        echo "  \"major_edits_code\": $MAJOR_EDITS_CODE,"
        echo "  \"major_edits_docs\": $MAJOR_EDITS_DOCS"
        echo "}"
    } > "${STATS_FILE}.${DATE}"

    echo "Log updated: $LOG_FILE"
    echo "Stats saved: ${STATS_FILE}.${DATE}"
    echo ""

    ###########################################################################
    # Commit changes (only relevant file types)
    ###########################################################################
    COMMIT_MSG="${1:-Daily code generation - $DATE}"
    echo "Committing changes..."

    # Add only tracked file types and line counting files
    git add --all '*.py' '*.sh' '*.md' '*.txt' '*.pdf' \
            LINE_COUNT_LOG.md LINE_COUNT_STATS.json.* .gitignore 2>/dev/null || true

    git commit -m "$COMMIT_MSG" \
        -m "Total: $TOTAL_TODAY lines (Code: $TOTAL_CODE, Docs: $TOTAL_DOCS)" \
        -m "New: $NEW_LINES, Modified: $MODIFIED_LINES, Major edits: $MAJOR_EDITS"

    echo ""
    echo "✓ Changes committed successfully!"
    echo ""

else
    echo "No uncommitted changes found."
    echo ""
fi

###############################################################################
# Show cumulative statistics
###############################################################################
echo "================================================================"
echo "CUMULATIVE STATISTICS (All Time)"
echo "================================================================"

if [ -d .git ]; then
    # Total commits
    TOTAL_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo 0)

    echo ""
    echo "Current lines by file type:"

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
                # For PDFs, count number of files (can't count lines)
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
    echo "Total commits: $TOTAL_COMMITS"
fi

echo "================================================================"
echo ""
echo "To view detailed statistics:"
echo "  bash view_line_stats.sh today      # Today's stats"
echo "  bash view_line_stats.sh week       # Last 7 days"
echo "  bash view_line_stats.sh 2025-10-24 2025-11-02  # Date range"
echo ""
