# Changelog

## Version 1.1 (2025-10-28)

### 🔧 Fixed: Selective File Tracking

**Problem:** Initial commit tracked ALL files in directory, including:
- Conda environments
- Data files
- Cache directories
- Build artifacts
- Thousands of unnecessary files

**Solution:** Now only tracks relevant files automatically

### Changes Made

1. **Auto-generated .gitignore**
   - Creates sensible .gitignore on first run
   - Excludes Python caches, data dirs, conda envs, IDE files
   - Users can customize by editing .gitignore

2. **Selective git add**
   - Changed from: `git add .` (adds everything)
   - Changed to: `git add --all '*.py' '*.sh' '*.md' '*.txt' '*.pdf'`
   - Only tracks: code files + documentation + line count files

3. **Updated Documentation**
   - README now explains what gets tracked/ignored
   - Clear list of included/excluded file types

### What Gets Tracked Now

✅ **Tracked (counted):**
- `.py` - Python code
- `.sh` - Shell scripts
- `.md` - Markdown docs
- `.txt` - Text files
- `.pdf` - PDF docs
- `LINE_COUNT_LOG.md` - Generated log
- `LINE_COUNT_STATS.json.*` - Statistics
- `.gitignore` - Git configuration

❌ **Automatically Ignored:**
- `__pycache__/`, `*.pyc` - Python cache
- `data/`, `datasets/` - Data directories
- `checkpoints/`, `logs/` - Training artifacts
- `conda-envs/`, `venv/` - Virtual environments
- `.vscode/`, `.idea/` - IDE files
- `build/`, `dist/` - Build artifacts

### Migration for Existing Users

If you already ran the old version:

```bash
# Option 1: Start fresh with clean git history
rm -rf .git LINE_COUNT_LOG.md LINE_COUNT_STATS.json.*
bash daily_line_count.sh "Fresh start with v1.1"

# Option 2: Clean up existing git repo
git rm --cached -r .  # Untrack all files
bash daily_line_count.sh "Migrated to v1.1 with selective tracking"
```

### Benefits

- ⚡ **Much faster** initial commit (100s of files vs thousands)
- 💾 **Smaller repo size** (KB vs GB)
- 🎯 **Cleaner history** (only relevant code changes)
- 🚀 **Better performance** (fewer files to track)

---

## Version 1.0 (2025-10-28)

Initial release with:
- 7 comprehensive counting rules
- Code vs document separation
- Major edit detection (>50%)
- Daily/weekly/date range queries
- JSON statistics export
- Cross-platform compatibility
