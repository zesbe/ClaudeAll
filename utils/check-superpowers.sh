#!/bin/bash

# Superpowers Installation Checker
# Verifies Superpowers integration with Claude

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔍 Checking Superpowers Integration${NC}"
echo "===================================="
echo ""

CLAUDE_DIR="$HOME/.claude"
SUPERPOWERS_DIR="$CLAUDE_DIR/plugins/superpowers"

# Check if directories exist
echo -e "${BLUE}Directory Structure:${NC}"
dirs_exist=0

if [[ -d "$CLAUDE_DIR" ]]; then
    echo -e "  ${GREEN}✓${NC} Claude directory: $CLAUDE_DIR"
    ((dirs_exist++))
else
    echo -e "  ${RED}✗${NC} Claude directory not found"
fi

if [[ -d "$SUPERPOWERS_DIR" ]]; then
    echo -e "  ${GREEN}✓${NC} Superpowers components: $SUPERPOWERS_DIR"
    ((dirs_exist++))
else
    echo -e "  ${RED}✗${NC} Superpowers components not found"
fi

# Check skills
if [[ -d "$CLAUDE_DIR/skills" ]]; then
    skill_count=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -type d | wc -l)
    skill_count=$((skill_count - 1))  # Subtract parent directory
    echo -e "  ${GREEN}✓${NC} Skills directory: $skill_count skills"
    ((dirs_exist++))
else
    echo -e "  ${RED}✗${NC} Skills directory not found"
fi

# Check other components
echo ""
echo -e "${BLUE}Components:${NC}"

components=(
    "agents:Specialized agents"
    "commands:Core commands"
    "hooks:Workflow hooks"
    "lib:Core library"
)

for comp in "${components[@]}"; do
    name=$(echo $comp | cut -d: -f1)
    desc=$(echo $comp | cut -d: -f2)

    if [[ -d "$CLAUDE_DIR/$name" ]]; then
        file_count=$(find "$CLAUDE_DIR/$name" -type f | wc -l)
        echo -e "  ${GREEN}✓${NC} $desc: $file_count files"
    else
        echo -e "  ${RED}✗${NC} $desc: Not found"
    fi
done

# Check specific important files
echo ""
echo -e "${BLUE}Key Files:${NC}"

key_files=(
    "$CLAUDE_DIR/lib/skills-core.js:Core library"
    "$CLAUDE_DIR/hooks/hooks.json:Hooks config"
    "$CLAUDE_DIR/commands/brainstorm.md:Brainstorm command"
    "$CLAUDE_DIR/skills/brainstorming/SKILL.md:Brainstorm skill"
)

for file in "${key_files[@]}"; do
    path=$(echo $file | cut -d: -f1)
    desc=$(echo $file | cut -d: -f2)

    if [[ -f "$path" ]]; then
        echo -e "  ${GREEN}✓${NC} $desc"
    else
        echo -e "  ${RED}✗${NC} $desc: Missing"
    fi
done

# Summary
echo ""
echo -e "${BLUE}Summary:${NC}"

if [[ $dirs_exist -eq 3 ]]; then
    echo -e "${GREEN}✅ Superpowers is fully integrated!${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  claude"
    echo "  /superpowers:brainstorm    # Design refinement"
    echo "  /superpowers:write-plan    # Implementation plan"
    echo "  /superpowers:execute-plan  # Execute workflow"
    echo ""
    echo -e "${YELLOW}To reinstall Superpowers:${NC}"
    echo "  curl -fsSL https://raw.githubusercontent.com/zesbe/Claude-All-New/main/utils/install-curl.sh | bash"
else
    echo -e "${RED}❌ Superpowers integration incomplete${NC}"
    echo ""
    echo -e "${YELLOW}To install Superpowers:${NC}"
    echo "  curl -fsSL https://raw.githubusercontent.com/zesbe/Claude-All-New/main/utils/install-curl.sh | bash"
fi

echo ""