#!/bin/bash

# Update and Publish Script for Claude-All

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get new version from argument or prompt
if [ -z "$1" ]; then
    echo -e "${BLUE}Current version:${NC}"
    cat VERSION
    read -p "Enter new version (e.g., 8.1.5): " NEW_VERSION
else
    NEW_VERSION=$1
fi

echo -e "${BLUE}Updating to version ${NEW_VERSION}...${NC}"

# 1. Update VERSION file
echo $NEW_VERSION > VERSION
echo -e "${GREEN}✓ Updated VERSION${NC}"

# 2. Update package.json
sed -i "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" package.json
echo -e "${GREEN}✓ Updated package.json${NC}"

# 3. Update README.md (all version references)
sed -i "s/v[0-9]\+\.[0-9]\+\.[0-9]\+/v$NEW_VERSION/g" README.md
sed -i "s/Version\*\*: [0-9]\+\.[0-9]\+\.[0-9]\+/Version**: $NEW_VERSION/g" README.md
echo -e "${GREEN}✓ Updated README.md${NC}"

# 4. Git commit
git add VERSION package.json README.md
git commit -m "🚀 Bump version to $NEW_VERSION

Updated version across all files for release $NEW_VERSION

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
echo -e "${GREEN}✓ Committed changes${NC}"

# 5. Push to GitHub
echo -e "${BLUE}Pushing to GitHub...${NC}"
git push origin main
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Pushed to GitHub${NC}"
else
    echo -e "${RED}✗ Failed to push to GitHub${NC}"
    echo -e "${YELLOW}Tip: Make sure you're authenticated with GitHub${NC}"
    exit 1
fi

# 6. Publish to npm
echo -e "${BLUE}Publishing to npm...${NC}"
npm publish --access public
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Published to npm${NC}"
else
    echo -e "${RED}✗ Failed to publish to npm${NC}"
    echo -e "${YELLOW}Tip: Make sure you're logged in with 'npm login'${NC}"
    exit 1
fi

# 7. Verify
echo -e "${BLUE}Verifying publication...${NC}"
sleep 3
PUBLISHED_VERSION=$(npm view claude-all-ai-launcher version)
echo -e "${GREEN}✓ npm version: $PUBLISHED_VERSION${NC}"

# 8. Summary
echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}✨ Update and publish completed! ✨${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${BLUE}📦 Package:${NC} claude-all-ai-launcher"
echo -e "${BLUE}🔖 Version:${NC} $NEW_VERSION"
echo -e "${BLUE}🐙 GitHub:${NC} https://github.com/zesbe/ClaudeAll"
echo -e "${BLUE}📦 npm:${NC} https://www.npmjs.com/package/claude-all-ai-launcher"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Test installation: ${BLUE}npm install -g claude-all-ai-launcher@$NEW_VERSION${NC}"
echo -e "  2. Verify: ${BLUE}claude-all --version${NC}"
echo -e "  3. Create GitHub release (optional)"
echo ""
