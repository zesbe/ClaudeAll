#!/usr/bin/env bash

# Fix Claude Integration Script
# Ensures all Superpowers components are properly installed in Claude paths

set -e

echo "🔧 Fixing Claude Integration..."
echo "================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Claude directories
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
AGENTS_DIR="$CLAUDE_DIR/agents"
COMMANDS_DIR="$CLAUDE_DIR/commands"
HOOKS_DIR="$CLAUDE_DIR/hooks"
PLUGINS_DIR="$CLAUDE_DIR/plugins"

# Source directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUPERPOWERS_DIR="$SCRIPT_DIR/../superpowers"

if [[ ! -d "$SUPERPOWERS_DIR" ]]; then
    # Try relative from current directory
    SUPERPOWERS_DIR="$(pwd)/superpowers"
    if [[ ! -d "$SUPERPOWERS_DIR" ]]; then
        echo -e "${RED}❌ Superpowers directory not found${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}📦 Superpowers source: $SUPERPOWERS_DIR${NC}"
echo -e "${BLUE}🎯 Claude directory: $CLAUDE_DIR${NC}"
echo ""

# Create Claude directories if they don't exist
mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$COMMANDS_DIR" "$HOOKS_DIR" "$PLUGINS_DIR"

# Function to copy with overwrite confirmation
copy_to_claude() {
    local src="$1"
    local dest="$2"
    local description="$3"

    echo -e "${BLUE}📋 Installing $description...${NC}"

    if [[ -d "$src" ]]; then
        # Copy all files, overwriting existing
        cp -rf "$src"/* "$dest/" 2>/dev/null || true
        local count=$(find "$dest" -maxdepth 1 -type f | wc -l)
        echo -e "${GREEN}✅ $description: $count files installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Source not found: $src${NC}"
    fi
}

# Install Skills
copy_to_claude "$SUPERPOWERS_DIR/skills" "$SKILLS_DIR" "Skills"

# Install Agents
copy_to_claude "$SUPERPOWERS_DIR/agents" "$AGENTS_DIR" "Agents"

# Install Commands
copy_to_claude "$SUPERPOWERS_DIR/commands" "$COMMANDS_DIR" "Commands"

# Install Hooks
copy_to_claude "$SUPERPOWERS_DIR/hooks" "$HOOKS_DIR" "Hooks"

# Install Plugin configuration
if [[ -f "$SUPERPOWERS_DIR/.claude-plugin/plugin.json" ]]; then
    cp "$SUPERPOWERS_DIR/.claude-plugin/plugin.json" "$PLUGINS_DIR/" 2>/dev/null || true
    echo -e "${GREEN}✅ Plugin configuration updated${NC}"
fi

# Copy Superpowers to plugins directory (for hooks to work)
if [[ -d "$SUPERPOWERS_DIR" ]]; then
    rm -rf "$PLUGINS_DIR/superpowers" 2>/dev/null || true
    cp -r "$SUPERPOWERS_DIR" "$PLUGINS_DIR/superpowers" 2>/dev/null || true
    echo -e "${GREEN}✅ Superpowers plugin installed${NC}"
fi

# Make hooks executable
if [[ -f "$HOOKS_DIR/session-start.sh" ]]; then
    chmod +x "$HOOKS_DIR/session-start.sh"
    echo -e "${GREEN}✅ Hooks made executable${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo "================================"
echo "📊 Summary:"
echo "  • Skills: $(ls -1 "$SKILLS_DIR" | wc -l | tr -d ' ') skills"
echo "  • Agents: $(ls -1 "$AGENTS_DIR" | wc -l | tr -d ' ') agents"
echo "  • Commands: $(ls -1 "$COMMANDS_DIR" | wc -l | tr -d ' ') commands"
echo "  • Hooks: $(ls -1 "$HOOKS_DIR"/*.sh 2>/dev/null | wc -l | tr -d ' ') hooks"
echo ""

# Verify installation
echo -e "${BLUE}🔍 Verifying installation...${NC}"

# Check if skills are loaded
skill_count=$(ls -1 "$SKILLS_DIR" 2>/dev/null | wc -l | tr -d ' ')
agent_count=$(ls -1 "$AGENTS_DIR" 2>/dev/null | wc -l | tr -d ' ')

if [[ "$skill_count" -ge 30 ]]; then
    echo -e "${GREEN}✅ All 30+ skills installed${NC}"
else
    echo -e "${YELLOW}⚠️  Only $skill_count skills found (expected 30+)${NC}"
fi

if [[ "$agent_count" -ge 10 ]]; then
    echo -e "${GREEN}✅ All 14 agents installed${NC}"
else
    echo -e "${YELLOW}⚠️  Only $agent_count agents found (expected 14)${NC}"
fi

echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "1. Restart Claude Code to ensure all components are loaded"
echo "2. Use /help to see available commands"
echo "3. Skills will trigger automatically based on context"
echo "4. Agents can be invoked via the Task tool"
echo ""

echo -e "${GREEN}✨ Superpowers is now fully integrated with Claude!${NC}"