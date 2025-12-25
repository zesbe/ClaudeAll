#!/usr/bin/env bash

# Script to rename claude command to custom name
# Usage: ./rename-claude.sh [new-name]

set -e

NEW_NAME="${1:-ai}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🎨 Claude-All Rename Tool${NC}"
echo "========================="
echo ""

# Validate new name
if [[ ! "$NEW_NAME" =~ ^[a-zA-Z][a-zA-Z0-9-]*$ ]]; then
    echo -e "${YELLOW}⚠️  Invalid name: $NEW_NAME${NC}"
    echo "Name must start with letter and contain only letters, numbers, and hyphens"
    exit 1
fi

echo -e "${BLUE}Renaming 'claude' to '$NEW_NAME'...${NC}"
echo ""

# 1. Rename the main executable
MAIN_BIN="$HOME/.local/bin/claude-all"
NEW_MAIN_BIN="$HOME/.local/bin/$NEW_NAME"

if [[ -f "$MAIN_BIN" ]]; then
    cp "$MAIN_BIN" "$NEW_MAIN_BIN"
    chmod +x "$NEW_MAIN_BIN"
    echo -e "${GREEN}✅ Created $NEW_NAME command${NC}"
else
    echo -e "${YELLOW}⚠️  claude-all not found in ~/.local/bin${NC}"
fi

# 2. Update the executable to use new name internally
echo -e "${BLUE}Updating internal references...${NC}"
sed -i "s/claude --model/$NEW_NAME --model/g" "$NEW_MAIN_BIN"
sed -i "s/exec claude/exec $NEW_NAME/g" "$NEW_MAIN_BIN"

# 3. Create alias for backward compatibility
ALIAS_FILE="$HOME/.bashrc"
if [[ -f "$HOME/.zshrc" ]]; then
    ALIAS_FILE="$HOME/.zshrc"
fi

echo ""
echo -e "${BLUE}Adding alias to $ALIAS_FILE...${NC}"
cat << EOF >> "$ALIAS_FILE"

# Claude-All Alias (added by rename-claude.sh)
alias claude='$NEW_NAME'
EOF

echo -e "${GREEN}✅ Alias added: claude → $NEW_NAME${NC}"

# 4. Update completion (if exists)
if [[ -f "$HOME/.local/share/bash-completion/completions/claude" ]]; then
    cp "$HOME/.local/share/bash-completion/completions/claude" \
       "$HOME/.local/share/bash-completion/completions/$NEW_NAME" 2>/dev/null || true
    echo -e "${GREEN}✅ Completion updated${NC}"
fi

# 5. Create desktop entry (Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DESKTOP_FILE="$HOME/.local/share/applications/claude-all.desktop"
    if [[ -f "$DESKTOP_FILE" ]]; then
        sed -i "s/Name=Claude-All/Name=$NEW_NAME/g" "$DESKTOP_FILE"
        sed -i "s/Exec=claude-all/Exec=$NEW_NAME/g" "$DESKTOP_FILE"
        sed -i "s/Icon=claude/Icon=$NEW_NAME/g" "$DESKTOP_FILE"
        echo -e "${GREEN}✅ Desktop entry updated${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Rename Complete!${NC}"
echo "==================="
echo ""
echo "New command: ${BLUE}$NEW_NAME${NC}"
echo "Alias: ${YELLOW}claude → $NEW_NAME${NC}"
echo ""
echo "To apply changes:"
echo "1. Restart terminal or run: source $ALIAS_FILE"
echo "2. Use '$NEW_NAME' command instead of 'claude-all'"
echo ""
echo -e "${BLUE}Examples:${NC}"
echo "  $NEW_NAME                    # Run with menu"
echo "  $NEW_NAME --model glm-4      # Direct model"
echo "  $NEW_NAME --help             # Show help"
echo ""