# Line Counting Guide - Enhanced Tracking System

This guide explains how to track lines of code generated on a regular basis with enhanced capabilities including code/document separation, major edit detection, and flexible date range queries.

---

## Line Counting Rules

The system follows 7 comprehensive rules:

1. ✓ **Each file creation counts all lines in the file**
2. ✓ **Each edit counts only the lines changed**
3. ✓ **Multiple edits to the same file are counted separately**
4. ✓ **Major edits (>50% changed) count as new file + edited lines**
5. ✓ **Comments and blank lines are included** (part of code structure)
6. ✓ **All file types counted**: .py, .md, .sh, .txt, .pdf
7. ✓ **Separate tracking**: Code (.py, .sh) vs Documents (.md, .txt, .pdf)

---

## Recommended Approach: Git-Based Tracking

**Why Git?**
- Accurately tracks every line added/removed
- Counts each edit separately (perfect for your rules)
- Can view history anytime
- Automatic statistics generation
- Industry-standard version control

---

## Daily Workflow

### Step 1: Work on Your Code

Do your normal work - create files, edit code, etc.

### Step 2: Run Daily Line Count (End of Day)

```bash
bash daily_line_count.sh
```

**Or with custom commit message:**
```bash
bash daily_line_count.sh "Implemented quantum Hydra models"
```

**What it does:**
1. Counts new files (all lines) with code/docs categorization
2. Counts edited files (added lines only)
3. Detects major edits (>50% changed)
4. Generates today's statistics
5. Saves JSON statistics for date range queries
6. Commits changes to Git
7. Updates LINE_COUNT_LOG.md

**Output example:**
```
================================================================
Daily Line Count - 2025-10-27 10:30:00
================================================================

New files created:
  QuantumHydra.py: 820 lines [code]
  ClassicalHydra.py: 390 lines [code]
  README_HYDRA.md: 150 lines [docs]
Total new file lines: 1360 (Code: 1210, Docs: 150)

Modified files:
  compare_quantum_hydra.py: +50 lines (25% changed) [code]
  phase1_pretrain_gpu.sh: +80 lines (65% changed - MAJOR EDIT) [code]
Total modified lines: 130 (Code: 130, Docs: 0)
Major edits (>50% changed): 1 files (Code: 1, Docs: 0)

================================================================
TOTAL LINES GENERATED TODAY: 1490
  Code (.py, .sh):         1340 lines
  Documents (.md, .txt, .pdf): 150 lines

Breakdown:
  New files:               1360 lines
    - Code:                1210 lines
    - Documents:           150 lines
  Modifications:           130 lines
    - Code:                130 lines
    - Documents:           0 lines

  Major edits (>50%):      1 files count as new
    - Code:                1 files
    - Documents:           0 files
================================================================
```

### Step 3: View Statistics Anytime

```bash
# View today's statistics
bash view_line_stats.sh today

# View last 7 days
bash view_line_stats.sh week

# View custom date range (YYYY-MM-DD format)
bash view_line_stats.sh 2025-10-24 2025-11-02

# View all-time statistics
bash view_line_stats.sh all

# View the markdown log
bash view_line_stats.sh log
```

**All queries show:**
- Total lines (Code + Documents)
- Breakdown by code (.py, .sh) vs documents (.md, .txt, .pdf)
- New files, modifications, and major edits
- Daily breakdown for date ranges

---

## File Descriptions

### 1. daily_line_count.sh

**Purpose**: Main tracking script to run daily

**Features:**
- Automatically initializes Git if needed
- Counts new and modified lines separately
- **Categorizes files**: Code (.py, .sh) vs Documents (.md, .txt, .pdf)
- **Detects major edits**: Files with >50% changed
- **Saves JSON statistics**: For programmatic access and date range queries
- Updates LINE_COUNT_LOG.md automatically
- Commits changes with statistics in commit message
- Shows cumulative statistics with code/docs breakdown

**When to run**: At the end of each coding session or day

### 2. view_line_stats.sh

**Purpose**: View statistics anytime without committing

**Options:**
- `today` - Today's changes only (from JSON file)
- `week` - Last 7 days summary with daily breakdown
- `YYYY-MM-DD YYYY-MM-DD` - Custom date range (e.g., 2025-10-24 2025-11-02)
- `all` - All-time statistics (default)
- `log` - Show the markdown log file

**Features:**
- Aggregates JSON statistics across date ranges
- Shows code vs documents breakdown
- Daily breakdown for week and custom range queries
- No Git operations (read-only)

### 3. LINE_COUNT_LOG.md (auto-generated)

**Purpose**: Human-readable daily log

**Format:**
```markdown
## 2025-10-27

**Total: 1490 lines** (Code: 1340, Docs: 150)

- New files: 1360 lines (Code: 1210, Docs: 150)
- Modifications: 130 lines (Code: 130, Docs: 0)
- Major edits (>50%): 1 files (Code: 1, Docs: 0)

<details>
<summary>Files changed (click to expand)</summary>

\`\`\`
A  QuantumHydra.py
M  compare_quantum_hydra.py
\`\`\`

</details>
```

### 4. LINE_COUNT_STATS.json.YYYY-MM-DD (auto-generated)

**Purpose**: Machine-readable daily statistics for date range queries

**Format:**
```json
{
  "date": "2025-10-27",
  "timestamp": "2025-10-27 14:30:00",
  "total_lines": 1490,
  "code_lines": 1340,
  "docs_lines": 150,
  "new_files_lines": 1360,
  "new_files_code": 1210,
  "new_files_docs": 150,
  "modified_lines": 130,
  "modified_code": 130,
  "modified_docs": 0,
  "major_edits": 1,
  "major_edits_code": 1,
  "major_edits_docs": 0
}
```

**Usage**: Automatically created by `daily_line_count.sh` and read by `view_line_stats.sh` for aggregation

---

## Initial Setup

### First Time Setup

```bash
# Make scripts executable
chmod +x daily_line_count.sh view_line_stats.sh

# Run initial commit (if not already using Git)
bash daily_line_count.sh "Initial commit"
```

This will:
1. Initialize Git repository
2. Commit all existing files
3. Create LINE_COUNT_LOG.md

---

## Example Usage Scenarios

### Scenario 1: Daily Tracking

**Morning:**
```bash
# Start working...
```

**Evening:**
```bash
# Commit day's work and count lines
bash daily_line_count.sh "Day 1: Implemented quantum circuits"

# Output:
# TOTAL LINES GENERATED TODAY: 850
#   New files:      820 lines
#   Modifications:  30 lines
```

### Scenario 2: Multiple Sessions Per Day

**Session 1 (Morning):**
```bash
# Work on feature A
bash daily_line_count.sh "Morning: Started feature A"
# Output: 500 lines
```

**Session 2 (Afternoon):**
```bash
# Work on feature B
bash daily_line_count.sh "Afternoon: Completed feature B"
# Output: 300 lines
```

**View total for today:**
```bash
bash view_line_stats.sh today
# Shows combined: 800 lines today
```

### Scenario 3: Weekly Review

```bash
bash view_line_stats.sh week

# Output:
# ================================================================
# Last 7 days summary:
# ================================================================
# Date range: 2025-10-21 to 2025-10-28
#
# TOTAL: 36212 lines
#   Code (.py, .sh):           28450 lines
#   Documents (.md, .txt, .pdf): 7762 lines
#
# Breakdown:
#   New files:                 30150 lines
#   Modifications:             6062 lines
#   Major edits (>50%):        12 files
#
# Daily breakdown:
# ----------------
# 2025-10-27:  1188 lines (Code:   950, Docs:   238)
# 2025-10-26:  6444 lines (Code:  5820, Docs:   624)
# 2025-10-24: 16708 lines (Code: 14200, Docs:  2508)
# 2025-10-23: 11872 lines (Code:  7480, Docs:  4392)
```

### Scenario 4: Custom Date Range Query

```bash
# Query specific date range
bash view_line_stats.sh 2025-10-24 2025-10-27

# Output:
# ================================================================
# Date range: 2025-10-24 to 2025-10-27
# ================================================================
#
# TOTAL: 24340 lines
#   Code (.py, .sh):           20970 lines
#   Documents (.md, .txt, .pdf): 3370 lines
#
# Breakdown:
#   New files:                 20150 lines
#   Modifications:             4190 lines
#   Major edits (>50%):        8 files
#
# Daily breakdown:
# ----------------
# 2025-10-24: 16708 lines (Code: 14200, Docs:  2508, Major:  3)
# 2025-10-26:  6444 lines (Code:  5820, Docs:   624, Major:  2)
# 2025-10-27:  1188 lines (Code:   950, Docs:   238, Major:  3)
```

---

## Advanced Usage

### View Detailed Git History

```bash
# See all commits with file statistics
git log --stat

# See commits from last week
git log --since="1 week ago" --stat

# See what changed in specific commit
git show <commit-hash> --stat

# Compare two dates
git diff --stat \
  $(git rev-list -1 --before="2025-10-23" HEAD) \
  $(git rev-list -1 --before="2025-10-27" HEAD)
```

### Generate Monthly Report

```bash
# Lines added per day in October
git log --since="2025-10-01" --until="2025-10-31" \
  --pretty=format:"%ad" --date=short | sort | uniq -c

# Total lines in October
git diff --stat \
  $(git rev-list -1 --before="2025-10-01" HEAD) \
  $(git rev-list -1 --before="2025-11-01" HEAD)
```

### Count Lines by Author (if multiple people)

```bash
git log --author="Claude" --pretty=tformat: --numstat | \
  awk '{added += $1; removed += $2} END {print "Added:", added, "Removed:", removed}'
```

---

## Comparison with Manual Counting

| Method | Accuracy | Ease of Use | Tracks Edits Separately | Historical View |
|--------|----------|-------------|------------------------|-----------------|
| **Git-based (Recommended)** | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓✓ |
| Manual log file | ✓ | ✓ | ✓ (if diligent) | ✓ |
| File watching script | ✓✓ | ✓✓ | ✗ (hard to track) | ✓ |
| Manual counting | ✓ | ✗ | ✗ | ✗ |

---

## Tips for Accurate Tracking

### 1. Commit Frequently
```bash
# Good: Multiple commits per day
bash daily_line_count.sh "Morning: Feature A"
bash daily_line_count.sh "Afternoon: Feature B"

# Less accurate: One commit for entire week
```

### 2. Use Descriptive Commit Messages
```bash
# Good
bash daily_line_count.sh "Implemented 3 new optimizers (SPSA, CMA, PSO)"

# Less useful
bash daily_line_count.sh "Updates"
```

### 3. Review Before Committing
```bash
# Check what's changed
git status
git diff --stat

# Then commit
bash daily_line_count.sh "Detailed description"
```

### 4. Keep LINE_COUNT_LOG.md Updated
The log file is automatically updated each time you run `daily_line_count.sh`. Review it periodically:
```bash
bash view_line_stats.sh log
```

---

## Troubleshooting

### Problem: Git not initialized

**Solution:**
```bash
bash daily_line_count.sh
# Script will automatically initialize Git
```

### Problem: Want to exclude certain files

**Solution:** Create `.gitignore`:
```bash
cat > .gitignore << EOF
# Ignore these from line counts
__pycache__/
*.pyc
.ipynb_checkpoints/
conda-cache/
conda-envs/
EOF
```

### Problem: Need to count retroactively

**Solution:** If you already have commits:
```bash
# Count lines between two dates
git diff --stat \
  $(git rev-list -1 --before="2025-10-23" HEAD)..HEAD

# Or use the existing CODE_GENERATION_DETAILED_COUNT.md
cat CODE_GENERATION_DETAILED_COUNT.md
```

### Problem: Accidentally committed wrong files

**Solution:**
```bash
# Undo last commit (keeps changes)
git reset --soft HEAD~1

# Check what would be committed
git status

# Re-commit with correct files
bash daily_line_count.sh "Corrected commit"
```

---

## Alternative: Simple Manual Log (If Git Not Desired)

If you prefer not to use Git, here's a simple manual approach:

```bash
# Create simple log script
cat > log_lines.sh << 'EOF'
#!/bin/bash
DATE=$(date +"%Y-%m-%d")
echo "## $DATE" >> manual_line_log.txt
echo "" >> manual_line_log.txt
echo "Files created/edited:" >> manual_line_log.txt
# Manually list your changes here
echo "  QuantumHydra.py: 820 lines (created)" >> manual_line_log.txt
echo "  README.md: 50 lines (edited)" >> manual_line_log.txt
echo "" >> manual_line_log.txt
EOF

chmod +x log_lines.sh
```

**But Git-based is much better because:**
- Automatic line counting
- Can't forget what you changed
- Complete history tracking
- Industry standard

---

## Summary

**For regular line counting, use this enhanced workflow:**

1. **Daily**: `bash daily_line_count.sh "Description of work"`
2. **View stats**: `bash view_line_stats.sh [today|week|YYYY-MM-DD YYYY-MM-DD|all|log]`
3. **Review**: Check LINE_COUNT_LOG.md and JSON statistics periodically

**Benefits:**
- ✓ **7 comprehensive rules** including major edit detection (>50%)
- ✓ **Code vs document separation** (.py, .sh vs .md, .txt, .pdf)
- ✓ **Flexible date queries** (daily, weekly, custom range)
- ✓ **JSON statistics** for programmatic access
- ✓ Counts each edit separately
- ✓ Automatic and accurate
- ✓ Historical tracking
- ✓ No manual effort needed

---

## Quick Reference

```bash
# Daily use
bash daily_line_count.sh                # Commit and count today's work
bash daily_line_count.sh "Custom msg"   # With custom message

# View statistics
bash view_line_stats.sh today           # Today only
bash view_line_stats.sh week            # Last 7 days
bash view_line_stats.sh 2025-10-24 2025-11-02  # Custom date range
bash view_line_stats.sh all             # All time (default)
bash view_line_stats.sh log             # Show markdown log

# Git commands
git log --stat                          # Detailed history
git diff --stat HEAD~1                  # Last commit stats
git status                              # Current changes

# JSON statistics files
ls LINE_COUNT_STATS.json.*              # List all daily JSON stats
cat LINE_COUNT_STATS.json.2025-10-27    # View specific day's JSON
```

**Key Features:**
- **7 counting rules** including major edit detection (>50% changed)
- **Code/docs separation**: .py, .sh vs .md, .txt, .pdf
- **Flexible queries**: daily, weekly, or custom date range
- **JSON statistics**: Machine-readable format for automation
- **Git-based**: Accurate tracking with full history

---

*This enhanced tracking system provides comprehensive, automated line counting with advanced categorization and flexible date queries.*
