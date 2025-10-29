# GitHub Setup Instructions

Step-by-step guide to publish this repository on GitHub.

## 🚀 Quick Start (5 Minutes)

### Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and log in
2. Click the **"+"** icon (top right) → **"New repository"**
3. Fill in:
   - **Repository name**: `line-counting-system` (or your preferred name)
   - **Description**: "Automated daily tracking of code and documentation lines"
   - **Visibility**: Public (recommended) or Private
   - **DO NOT** initialize with README (we have our own)
4. Click **"Create repository"**

### Step 2: Push to GitHub

```bash
# Navigate to the repository directory
cd /pscratch/sd/j/junghoon/line-counting-github

# Initialize Git
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: Line Counting System v1.1"

# Add your GitHub repository as remote
# Replace YOUR_USERNAME and REPO_NAME with your actual values
git remote add origin https://github.com/YOUR_USERNAME/line-counting-system.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Verify on GitHub

1. Refresh your GitHub repository page
2. You should see all files uploaded
3. README.md will be displayed on the main page

## 📝 Customize Before Publishing

### Update README.md

Replace placeholders in `README.md`:

```bash
# Find and replace YOUR_USERNAME with your actual GitHub username
sed -i 's/YOUR_USERNAME/your-actual-username/g' README.md

# Or manually edit
vim README.md
# Search for: YOUR_USERNAME
# Replace with: your-actual-username
```

### Update Examples

In `docs/EXAMPLES.md`, update URLs:
```bash
sed -i 's/YOUR_USERNAME/your-actual-username/g' docs/EXAMPLES.md
```

## 🎨 Optional: Add GitHub Enhancements

### Add Topics/Tags

On GitHub repository page:
1. Click ⚙️ (Settings gear next to "About")
2. Add topics: `bash`, `git`, `productivity`, `tracking`, `line-counter`, `shell-script`
3. Save changes

### Add Description

1. Click ⚙️ (Settings gear)
2. Add: "Automated daily tracking of code and documentation lines with Git"
3. Add website: `https://github.com/YOUR_USERNAME/line-counting-system`
4. Save

### Create Releases

```bash
# Tag current version
git tag -a v1.1 -m "Version 1.1: Selective file tracking"
git push origin v1.1
```

Then on GitHub:
1. Go to **Releases** tab
2. Click **"Create a new release"**
3. Choose tag: `v1.1`
4. Release title: "Version 1.1 - Selective File Tracking"
5. Description: Copy from CHANGELOG.md
6. Click **"Publish release"**

## 🔐 Authentication Options

### Option 1: HTTPS with Personal Access Token (Recommended)

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Select scopes: `repo` (full control)
4. Copy token (you'll only see it once!)
5. Use token as password when pushing:
   ```bash
   git push -u origin main
   # Username: your-username
   # Password: your-token (not your GitHub password!)
   ```

### Option 2: SSH (Advanced)

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key

# Use SSH URL instead of HTTPS
git remote set-url origin git@github.com:YOUR_USERNAME/line-counting-system.git
git push -u origin main
```

## 📢 Promote Your Repository

### Add to README.md

In your personal profile README:
```markdown
## 🔧 Tools I've Built

- [Line Counting System](https://github.com/YOUR_USERNAME/line-counting-system) - Track your daily coding productivity
```

### Share on Social Media

**Twitter/X:**
```
🎉 Just open-sourced my Line Counting System!

Track your daily code productivity with:
✅ Automated Git-based tracking
✅ Code vs docs separation
✅ JSON export for analysis

Check it out: https://github.com/YOUR_USERNAME/line-counting-system

#opensource #productivity #developer
```

**LinkedIn:**
```
I'm excited to share my Line Counting System - an open-source tool for tracking daily coding productivity.

Features:
- Automated line counting with Git
- Separates code (.py, .sh) from docs (.md, .txt)
- Flexible queries (daily, weekly, date ranges)
- Cross-platform support

Perfect for developers, students, and researchers who want to measure their output.

GitHub: https://github.com/YOUR_USERNAME/line-counting-system
```

## 📊 Add GitHub Actions (Optional)

Create `.github/workflows/test.yml`:

```yaml
name: Test Scripts

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]

    steps:
    - uses: actions/checkout@v3

    - name: Test scripts are executable
      run: |
        chmod +x daily_line_count.sh view_line_stats.sh

    - name: Verify bash syntax
      run: |
        bash -n daily_line_count.sh
        bash -n view_line_stats.sh

    - name: Basic functionality test
      run: |
        git config --global user.email "test@example.com"
        git config --global user.name "Test User"
        mkdir test_project
        cd test_project
        echo "print('hello')" > test.py
        cp ../daily_line_count.sh .
        bash daily_line_count.sh "Test commit"
```

## 🌟 Get More Stars

1. **Add screenshots** - Show example output in README
2. **Create a demo video** - Record usage walkthrough
3. **Write blog post** - Explain why you built it
4. **Submit to lists**:
   - [Awesome Shell](https://github.com/alebcay/awesome-shell)
   - [Awesome Productivity](https://github.com/jyguyomarch/awesome-productivity)
5. **Enable Discussions** - Repository → Settings → Features → Discussions

## ✅ Pre-Publication Checklist

Before pushing to GitHub, verify:

- [ ] Updated README.md with your GitHub username
- [ ] Updated docs/EXAMPLES.md with your username
- [ ] LICENSE file is present (MIT)
- [ ] Scripts are tested and working
- [ ] CHANGELOG.md is up to date
- [ ] .gitignore is configured
- [ ] No sensitive information in code
- [ ] All links work correctly

## 📝 After Publishing

1. **Star your own repo** (shows it's active)
2. **Watch for issues** (enable notifications)
3. **Respond to issues quickly** (within 24-48 hours)
4. **Accept pull requests** (review and merge contributions)
5. **Tag releases** (v1.1, v1.2, etc.)
6. **Update regularly** (shows project is maintained)

## 🤝 Community Building

### Good First Issues

Label some issues as "good first issue":
- Add support for more file types
- Improve error messages
- Add unit tests
- Translate documentation

### Code of Conduct

Create `CODE_OF_CONDUCT.md`:
```markdown
# Code of Conduct

Be respectful, inclusive, and professional.
```

### Contributing Guide

Create `CONTRIBUTING.md`:
```markdown
# Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request
```

## 🎉 You're Done!

Your repository is now live on GitHub. Share it with the world! 🚀

Need help? Open an issue or check [GitHub Docs](https://docs.github.com).
