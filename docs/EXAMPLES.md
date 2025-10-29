# Usage Examples

This document provides real-world examples of using the Line Counting System.

## Table of Contents

- [Basic Workflows](#basic-workflows)
- [Team Scenarios](#team-scenarios)
- [Academic Use Cases](#academic-use-cases)
- [Advanced Queries](#advanced-queries)

---

## Basic Workflows

### Example 1: Solo Developer Daily Routine

**Morning:**
```bash
cd my_awesome_project
# ... code, code, code ...
```

**Evening:**
```bash
bash daily_line_count.sh "Implemented user authentication feature"
```

**Output:**
```
================================================================
TOTAL LINES GENERATED TODAY: 420
  Code (.py, .sh):         380 lines
  Documents (.md, .txt, .pdf): 40 lines

Breakdown:
  New files:               350 lines
    - Code:                320 lines (auth.py, middleware.sh)
    - Documents:           30 lines (AUTH_GUIDE.md)
  Modifications:           70 lines
    - Code:                60 lines (main.py, config.py)
    - Documents:           10 lines (README.md)
================================================================
```

### Example 2: Multiple Sessions Per Day

**Session 1 (Morning - 9 AM):**
```bash
bash daily_line_count.sh "Morning: Started payment integration"
# Output: 250 lines
```

**Session 2 (Afternoon - 2 PM):**
```bash
bash daily_line_count.sh "Afternoon: Fixed bugs in payment module"
# Output: 85 lines
```

**Session 3 (Evening - 6 PM):**
```bash
bash daily_line_count.sh "Evening: Added tests for payments"
# Output: 180 lines
```

**View today's total:**
```bash
bash view_line_stats.sh today
# Output: 515 lines total today
```

### Example 3: Weekly Review

**Friday afternoon:**
```bash
bash view_line_stats.sh week
```

**Output:**
```
================================================================
Last 7 days summary:
================================================================
Date range: 2025-10-21 to 2025-10-28

TOTAL: 2,845 lines
  Code (.py, .sh):           2,420 lines
  Documents (.md, .txt, .pdf): 425 lines

Daily breakdown:
----------------
2025-10-28 (Mon):   420 lines (Code:   380, Docs:    40)
2025-10-27 (Sun):     0 lines (Day off)
2025-10-26 (Sat):   120 lines (Code:   120, Docs:     0)
2025-10-25 (Fri):   580 lines (Code:   500, Docs:    80)
2025-10-24 (Thu):   685 lines (Code:   560, Docs:   125)
2025-10-23 (Wed):   490 lines (Code:   420, Docs:    70)
2025-10-22 (Tue):   550 lines (Code:   440, Docs:   110)
```

---

## Team Scenarios

### Example 4: Team Member Onboarding

**New team member setup:**
```bash
# Clone team project
git clone https://github.com/company/project.git
cd project

# Install line counting
curl -O https://raw.githubusercontent.com/JHPark9090/line-counting-system/main/daily_line_count.sh
curl -O https://raw.githubusercontent.com/JHPark9090/line-counting-system/main/view_line_stats.sh
chmod +x daily_line_count.sh view_line_stats.sh

# Initialize personal tracking
bash daily_line_count.sh "Joined the team - setup complete"
```

### Example 5: Sprint Report

**End of 2-week sprint:**
```bash
bash view_line_stats.sh 2025-10-14 2025-10-28
```

**Output:**
```
================================================================
Date range: 2025-10-14 to 2025-10-28 (Sprint 12)
================================================================

TOTAL: 5,680 lines
  Code (.py, .sh):           4,920 lines
  Documents (.md, .txt, .pdf): 760 lines

Breakdown:
  New files:                 4,200 lines
  Modifications:             1,480 lines
  Major edits (>50%):        8 files

Daily breakdown:
----------------
Week 1: 2,850 lines
Week 2: 2,830 lines
```

**Share with team:**
```bash
bash view_line_stats.sh 2025-10-14 2025-10-28 > sprint12_report.txt
cat sprint12_report.txt  # Send to team lead
```

---

## Academic Use Cases

### Example 6: PhD Research Tracking

**Track thesis code development:**

```bash
# Start of research project
bash daily_line_count.sh "Initial data preprocessing pipeline"

# Weekly throughout PhD
bash daily_line_count.sh "Week 32: Improved model architecture"

# View progress quarterly
bash view_line_stats.sh 2025-07-01 2025-09-30  # Q3 2025
```

**Quarterly report:**
```
Q3 2025 Research Output:
- Total: 12,450 lines
- Code (experiments): 10,200 lines
- Documents (papers/docs): 2,250 lines
- Major refactors: 15 files
```

### Example 7: Course Assignment Tracking

**Computer Science student:**

```bash
# Assignment 1 (Week 1-2)
bash view_line_stats.sh 2025-09-01 2025-09-15
# Output: 850 lines (algorithms.py, report.md)

# Assignment 2 (Week 3-4)
bash view_line_stats.sh 2025-09-16 2025-09-30
# Output: 1,240 lines (ml_model.py, analysis.md)

# Semester summary
bash view_line_stats.sh 2025-09-01 2025-12-31
# Output: 8,450 lines total
```

---

## Advanced Queries

### Example 8: Monthly Reports

**Generate monthly productivity:**

```bash
# October 2025
bash view_line_stats.sh 2025-10-01 2025-10-31 > october_2025.txt

# November 2025
bash view_line_stats.sh 2025-11-01 2025-11-30 > november_2025.txt

# Compare months
cat october_2025.txt november_2025.txt
```

### Example 9: JSON Analysis with jq

**Programmatic analysis:**

```bash
# Get total lines for last 7 days
for file in LINE_COUNT_STATS.json.2025-10-{22..28}; do
    if [ -f "$file" ]; then
        jq '.total_lines' "$file"
    fi
done | awk '{sum+=$1} END {print "Total:", sum}'

# Average daily output
jq -s 'map(.total_lines) | add / length' LINE_COUNT_STATS.json.2025-10-*

# Code vs docs ratio
jq -s '[.[] | {date:.date, ratio:(.code_lines/.total_lines*100|round)}]' LINE_COUNT_STATS.json.2025-10-*
```

### Example 10: Git Integration

**View alongside Git history:**

```bash
# Lines generated vs commits
git log --oneline --since="1 week ago" | wc -l
bash view_line_stats.sh week

# Detailed comparison
git log --stat --since="2025-10-01" --until="2025-10-31"
bash view_line_stats.sh 2025-10-01 2025-10-31
```

---

## Real-World Scenarios

### Scenario 1: Freelance Developer

**Tracking billable hours:**

```bash
# Client A - Week 1
cd client_a_project
bash daily_line_count.sh "Client A: Day 1 - Setup database"
bash daily_line_count.sh "Client A: Day 2 - API endpoints"
bash daily_line_count.sh "Client A: Day 3 - Frontend integration"

# End of week invoice
bash view_line_stats.sh week > client_a_week1_work.txt
# Attach to invoice as work evidence
```

### Scenario 2: Open Source Contributor

**Track contributions to projects:**

```bash
# Clone open source project
git clone https://github.com/awesome/project.git
cd project

# Install line counter
wget https://raw.githubusercontent.com/JHPark9090/line-counting-system/main/daily_line_count.sh
chmod +x daily_line_count.sh

# Track your contributions
bash daily_line_count.sh "Fixed issue #123 - memory leak"
bash daily_line_count.sh "Added feature #456 - dark mode"

# Summary for maintainer
bash view_line_stats.sh 2025-10-01 2025-10-31
# "Contributed 2,450 lines this month"
```

### Scenario 3: Code Bootcamp Student

**Track learning progress:**

```bash
# Week 1 - HTML/CSS
bash daily_line_count.sh "Day 1: Built first webpage"
bash daily_line_count.sh "Day 2: CSS styling practice"
# ...

# View weekly progress
bash view_line_stats.sh week

# Compare progress across weeks
bash view_line_stats.sh 2025-10-01 2025-10-07  # Week 1
bash view_line_stats.sh 2025-10-08 2025-10-14  # Week 2
bash view_line_stats.sh 2025-10-15 2025-10-21  # Week 3
```

---

## Tips & Tricks

### Tip 1: Automated Daily Commits

Add to cron (Linux/Mac):
```bash
# Run every day at 6 PM
0 18 * * * cd /path/to/project && bash daily_line_count.sh "Auto-commit $(date +\%F)" >> ~/linecounting.log 2>&1
```

### Tip 2: Git Aliases

```bash
# Add to ~/.gitconfig
[alias]
    count = "!bash daily_line_count.sh"
    stats = "!bash view_line_stats.sh"

# Usage
git count "My work today"
git stats week
```

### Tip 3: Export to CSV

```bash
# Convert JSON to CSV for Excel
echo "Date,Total,Code,Docs" > stats.csv
for file in LINE_COUNT_STATS.json.*; do
    date=$(jq -r '.date' "$file")
    total=$(jq '.total_lines' "$file")
    code=$(jq '.code_lines' "$file")
    docs=$(jq '.docs_lines' "$file")
    echo "$date,$total,$code,$docs" >> stats.csv
done
```

---

## Need More Help?

- See [DETAILED_GUIDE.md](DETAILED_GUIDE.md) for comprehensive documentation
- Check [README.md](../README.md) for quick reference
- Open an [issue](https://github.com/JHPark9090/line-counting-system/issues) for specific questions
