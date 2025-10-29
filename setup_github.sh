#!/bin/bash

################################################################################
# GitHub Repository Setup Helper
################################################################################
#
# This script helps you publish the Line Counting System to GitHub
#
# Usage:
#   bash setup_github.sh
#
################################################################################

echo "========================================================================"
echo "GitHub Repository Setup"
echo "========================================================================"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Error: Git is not installed"
    echo "Please install Git first: https://git-scm.com"
    exit 1
fi

echo "✓ Git is installed"
echo ""

# Get GitHub username
echo "Step 1: GitHub Configuration"
echo "-----------------------------"
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ Error: GitHub username is required"
    exit 1
fi

# Get repository name
read -p "Enter repository name [line-counting-system]: " REPO_NAME
REPO_NAME=${REPO_NAME:-line-counting-system}

echo ""
echo "Configuration:"
echo "  GitHub Username: $GITHUB_USERNAME"
echo "  Repository Name: $REPO_NAME"
echo "  Repository URL:  https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""

read -p "Is this correct? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "Aborted"
    exit 0
fi

echo ""
echo "Step 2: Update Documentation"
echo "----------------------------"

# Update README.md
if [ -f "README.md" ]; then
    sed -i.bak "s/YOUR_USERNAME/$GITHUB_USERNAME/g" README.md && rm README.md.bak 2>/dev/null || \
    sed -i '' "s/YOUR_USERNAME/$GITHUB_USERNAME/g" README.md
    echo "✓ Updated README.md"
fi

# Update EXAMPLES.md
if [ -f "docs/EXAMPLES.md" ]; then
    sed -i.bak "s/YOUR_USERNAME/$GITHUB_USERNAME/g" docs/EXAMPLES.md && rm docs/EXAMPLES.md.bak 2>/dev/null || \
    sed -i '' "s/YOUR_USERNAME/$GITHUB_USERNAME/g" docs/EXAMPLES.md
    echo "✓ Updated docs/EXAMPLES.md"
fi

echo ""
echo "Step 3: Initialize Git Repository"
echo "----------------------------------"

if [ -d .git ]; then
    echo "⚠️  Git repository already exists"
    read -p "Reinitialize? This will delete git history (y/n): " REINIT
    if [ "$REINIT" = "y" ]; then
        rm -rf .git
        git init
        echo "✓ Reinitialized Git repository"
    fi
else
    git init
    echo "✓ Initialized Git repository"
fi

echo ""
echo "Step 4: Create First Commit"
echo "---------------------------"

git add .
git commit -m "Initial commit: Line Counting System v1.1

Features:
- Automated line counting with Git
- Code vs document separation
- Major edit detection (>50%)
- Daily/weekly/date range queries
- JSON statistics export
- Cross-platform support
- Selective file tracking with .gitignore"

echo "✓ Created initial commit"

echo ""
echo "Step 5: Add GitHub Remote"
echo "-------------------------"

# Check if remote already exists
if git remote | grep -q origin; then
    echo "⚠️  Remote 'origin' already exists"
    EXISTING_URL=$(git remote get-url origin)
    echo "   Current URL: $EXISTING_URL"
    read -p "Update to new URL? (y/n): " UPDATE_REMOTE
    if [ "$UPDATE_REMOTE" = "y" ]; then
        git remote set-url origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
        echo "✓ Updated remote URL"
    fi
else
    git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    echo "✓ Added remote 'origin'"
fi

echo ""
echo "========================================================================"
echo "Setup Complete!"
echo "========================================================================"
echo ""
echo "Next Steps:"
echo ""
echo "1. Create GitHub repository:"
echo "   Go to: https://github.com/new"
echo "   Repository name: $REPO_NAME"
echo "   Description: Automated daily tracking of code and documentation lines"
echo "   Visibility: Public (recommended)"
echo "   DO NOT initialize with README, .gitignore, or license"
echo ""
echo "2. Push to GitHub:"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. View your repository:"
echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""
echo "========================================================================"
echo ""

# Offer to open GitHub in browser (if on desktop)
if command -v xdg-open &> /dev/null; then
    read -p "Open GitHub in browser? (y/n): " OPEN_BROWSER
    if [ "$OPEN_BROWSER" = "y" ]; then
        xdg-open "https://github.com/new" 2>/dev/null &
    fi
elif command -v open &> /dev/null; then
    read -p "Open GitHub in browser? (y/n): " OPEN_BROWSER
    if [ "$OPEN_BROWSER" = "y" ]; then
        open "https://github.com/new" 2>/dev/null &
    fi
fi

echo "For detailed instructions, see: GITHUB_SETUP.md"
echo ""
