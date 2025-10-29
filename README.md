# Line Counting System

> Automated daily tracking of code and documentation lines with Git-based history

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](https://github.com)
[![Shell](https://img.shields.io/badge/shell-bash-green)](https://www.gnu.org/software/bash/)

A simple, automated system to track lines of code and documentation you generate daily. Perfect for tracking productivity, measuring project progress, or documenting contributions.

## ✨ Features

- 🔢 **7 comprehensive counting rules** including major edit detection (>50% changed)
- 📊 **Code vs document separation** - Track .py, .sh separately from .md, .txt, .pdf
- 📅 **Flexible queries** - Daily, weekly, or custom date range statistics
- 📈 **JSON export** - Machine-readable statistics for automation
- 🎯 **Selective tracking** - Only tracks relevant files, ignores cache/data/build artifacts
- 🚀 **Auto-setup** - Initializes Git and creates .gitignore automatically
- 🌍 **Cross-platform** - Works on Linux, macOS, Windows (Git Bash/WSL)

## 🚀 Quick Start

### Prerequisites

- Git installed (`git --version` to check)
- Bash shell (Linux/Mac native, Windows use Git Bash or WSL)

### Installation

```bash
# Clone the repository
git clone https://github.com/JHPark9090/line-counting-system.git
cd line-counting-system

# Copy scripts to your project
cp daily_line_count.sh view_line_stats.sh /path/to/your/project/
cd /path/to/your/project/

# Make executable
chmod +x daily_line_count.sh view_line_stats.sh

# Initialize
bash daily_line_count.sh "Initial setup"
```

### Daily Usage

```bash
# At the end of your workday
bash daily_line_count.sh "Brief description of work"
```

### View Statistics

```bash
# Today's stats
bash view_line_stats.sh today

# Last 7 days
bash view_line_stats.sh week

# Custom date range
bash view_line_stats.sh 2025-10-24 2025-10-28

# All-time statistics
bash view_line_stats.sh all
```

## 📋 What Gets Tracked

### ✅ Tracked Files
- **Code**: `.py`, `.sh`
- **Documents**: `.md`, `.txt`, `.pdf`
- **System**: `LINE_COUNT_LOG.md`, `LINE_COUNT_STATS.json.*`

### ❌ Auto-Ignored
- Python cache (`__pycache__/`, `*.pyc`)
- Data directories (`data/`, `checkpoints/`, `logs/`)
- Virtual environments (`conda-envs/`, `venv/`, `env/`)
- IDE files (`.vscode/`, `.idea/`, `.DS_Store`)
- Build artifacts (`build/`, `dist/`, `*.egg-info/`)

*Automatically managed via `.gitignore`*

## 📖 Counting Rules

1. **Each file creation** → Counts all lines
2. **Each edit** → Counts only lines changed (added)
3. **Multiple edits** → Counted separately each time
4. **Major edits (>50%)** → File counts as "new" + edited lines counted
5. **Comments included** → All lines count (blank lines, comments, code)
6. **All file types** → .py, .md, .sh, .txt, .pdf
7. **Separate tracking** → Code (.py, .sh) vs Documents (.md, .txt, .pdf)

## 📊 Example Output

### Daily Count

```
================================================================
TOTAL LINES GENERATED TODAY: 475
  Code (.py, .sh):         375 lines
  Documents (.md, .txt, .pdf): 100 lines

Breakdown:
  New files:               350 lines
    - Code:                250 lines
    - Documents:           100 lines
  Modifications:           125 lines
    - Code:                125 lines
    - Documents:           0 lines

  Major edits (>50%):      1 files count as new
================================================================
```

### Weekly Summary

```
================================================================
Last 7 days summary:
================================================================
TOTAL: 3250 lines
  Code (.py, .sh):           2800 lines
  Documents (.md, .txt, .pdf): 450 lines

Daily breakdown:
----------------
2025-10-28:   475 lines (Code:   375, Docs:   100)
2025-10-27:   680 lines (Code:   520, Docs:   160)
2025-10-26:   920 lines (Code:   850, Docs:    70)
```

## 🛠️ Advanced Features

### Date Range Queries

```bash
# Specific period analysis
bash view_line_stats.sh 2025-10-01 2025-10-31
```

### JSON Statistics

Each day generates a JSON file for programmatic access:

```bash
# View JSON stats
cat LINE_COUNT_STATS.json.2025-10-28
```

**JSON format:**
```json
{
  "date": "2025-10-28",
  "total_lines": 475,
  "code_lines": 375,
  "docs_lines": 100,
  "new_files_lines": 350,
  "new_files_code": 250,
  "new_files_docs": 100,
  "modified_lines": 125,
  "modified_code": 125,
  "modified_docs": 0,
  "major_edits": 1,
  "major_edits_code": 1,
  "major_edits_docs": 0
}
```

### Custom Exclusions

Edit the auto-generated `.gitignore` to customize what gets tracked:

```bash
# Add custom exclusions
echo "my_custom_dir/" >> .gitignore
echo "*.tmp" >> .gitignore
```

## 🌍 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Linux | ✅ Tested | All distributions |
| macOS | ✅ Tested | Intel & Apple Silicon |
| Windows | ✅ Tested | Git Bash, WSL, Cygwin |
| HPC | ✅ Tested | SLURM, PBS, SGE |

**Tested Environments:**
- Ubuntu 20.04, 22.04
- macOS Ventura, Sonoma
- Windows 11 (Git Bash)
- Perlmutter HPC (Cray Linux)

## 📁 Repository Structure

```
.
├── daily_line_count.sh       # Main tracking script
├── view_line_stats.sh         # Query statistics
├── README.md                  # This file
├── LICENSE                    # MIT License
├── CHANGELOG.md               # Version history
└── docs/
    ├── DETAILED_GUIDE.md      # Comprehensive documentation
    └── EXAMPLES.md            # Usage examples
```

## 🤝 Use Cases

- **Personal Productivity**: Track your daily coding output
- **Project Progress**: Measure development velocity
- **Team Reporting**: Generate weekly/monthly contribution reports
- **Academic Research**: Document coding effort for papers/theses
- **Client Billing**: Evidence of work completed
- **Learning Tracking**: Monitor progress while learning to code

## ❓ FAQ

**Q: Will this slow down my work?**
A: No, scripts only run when you explicitly call them (2-5 seconds).

**Q: Can I use this with existing Git repositories?**
A: Yes! Works seamlessly with existing repos.

**Q: What if I forget to run it for a few days?**
A: Run it whenever you remember - it counts changes since the last commit.

**Q: Does this work with Claude Code?**
A: Yes! Perfect for tracking AI-assisted development.

**Q: Can multiple people use this on the same project?**
A: Yes, but each person should run it on their own branch/clone to avoid conflicts.

## 🐛 Troubleshooting

### "git: command not found"
Install Git:
- **Mac**: `brew install git`
- **Linux**: `sudo apt-get install git` or `sudo yum install git`
- **Windows**: Download from [git-scm.com](https://git-scm.com)

### "Permission denied"
```bash
chmod +x daily_line_count.sh view_line_stats.sh
```

### Want to start fresh
```bash
rm -rf .git LINE_COUNT_LOG.md LINE_COUNT_STATS.json.*
bash daily_line_count.sh "Fresh start"
```

## 📝 License

MIT License - feel free to use, modify, and distribute.

See [LICENSE](LICENSE) for details.

## 🙏 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📮 Contact

- **Issues**: [GitHub Issues](https://github.com/JHPark9090/line-counting-system/issues)
- **Discussions**: [GitHub Discussions](https://github.com/JHPark9090/line-counting-system/discussions)

## ⭐ Show Your Support

If this helped you track your productivity, give it a star! ⭐

---

**Made with ❤️ for developers who like to track their progress**
