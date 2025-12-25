#!/usr/bin/env bash

# Claude-All-New v7.0 Installation Script
# Installs all scripts to your system
# Includes Superpowers Library (30 skills + 14 agents)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Claude-All-New Installer${NC}"
echo "================================"
echo ""

# Check if running as root for system-wide install
if [[ "$1" == "--system" ]]; then
    INSTALL_DIR="/usr/local/bin"
    echo -e "${BLUE}Installing system-wide to $INSTALL_DIR${NC}"
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp -r bin/* "$INSTALL_DIR/"
    sudo chmod +x "$INSTALL_DIR/claude-all" "$INSTALL_DIR/api-manager"
    echo -e "${GREEN}✓ Installed to $INSTALL_DIR${NC}"
else
    INSTALL_DIR="$HOME/.local/bin"
    echo -e "${BLUE}Installing to $INSTALL_DIR${NC}"
    mkdir -p "$INSTALL_DIR"
    cp -r bin/* "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/claude-all" "$INSTALL_DIR/api-manager"

    # Add to PATH if not already there
    if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
        echo ""
        echo -e "${YELLOW}⚠️  Add this line to your ~/.bashrc or ~/.zshrc:${NC}"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
    fi
    echo -e "${GREEN}✓ Installed to $INSTALL_DIR${NC}"
fi

# Install Superpowers Skills for Claude
echo ""
echo -e "${BLUE}📦 Installing Superpowers for Claude...${NC}"
echo ""

# Create Claude directories
CLAUDE_DIR="$HOME/.claude"
CLAUDE_PLUGINS_DIR="$CLAUDE_DIR/plugins"
mkdir -p "$CLAUDE_PLUGINS_DIR"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/lib"

# Copy superpowers from local claude-all installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SUPERPOWERS_DIR="$SCRIPT_DIR/../superpowers"

if [[ -d "$LOCAL_SUPERPOWERS_DIR" ]]; then
    echo "Installing Superpowers from local copy..."

    # Create destination directory
    mkdir -p "$HOME/.claude/plugins/superpowers"

    # Copy all files except .git if exists
    cp -r "$LOCAL_SUPERPOWERS_DIR"/* "$HOME/.claude/plugins/superpowers/" 2>/dev/null || true

    SUPERPOWERS_DIR="$HOME/.claude/plugins/superpowers"

    echo -e "${GREEN}✓ Copied from local installation${NC}"
elif command -v git &> /dev/null; then
    echo "Local copy not found. Downloading from GitHub..."
    if [[ -d "$HOME/.claude/plugins/superpowers" ]]; then
        echo "Updating Superpowers..."
        (cd "$HOME/.claude/plugins/superpowers" && git pull)
    else
        echo "Downloading Superpowers..."
        git clone https://github.com/obra/superpowers.git "$HOME/.claude/plugins/superpowers"
    fi

    SUPERPOWERS_DIR="$HOME/.claude/plugins/superpowers"

    # Install as Claude plugin
    echo "Installing as Claude plugin..."

    # Copy plugin configuration
    if [[ -f "$SUPERPOWERS_DIR/.claude-plugin/plugin.json" ]]; then
        cp "$SUPERPOWERS_DIR/.claude-plugin/plugin.json" "$CLAUDE_PLUGINS_DIR/"
    fi

    # Copy marketplace configuration
    if [[ -f "$SUPERPOWERS_DIR/.claude-plugin/marketplace.json" ]]; then
        cp "$SUPERPOWERS_DIR/.claude-plugin/marketplace.json" "$CLAUDE_PLUGINS_DIR/"
    fi

    # Copy agents
    if [[ -d "$SUPERPOWERS_DIR/agents" ]]; then
        cp -r "$SUPERPOWERS_DIR/agents/"* "$CLAUDE_DIR/agents/"
        echo -e "${GREEN}✓ Agents installed${NC}"
    fi

    # Copy commands
    if [[ -d "$SUPERPOWERS_DIR/commands" ]]; then
        cp -r "$SUPERPOWERS_DIR/commands/"* "$CLAUDE_DIR/commands/"
        echo -e "${GREEN}✓ Commands installed${NC}"
    fi

    # Copy hooks
    if [[ -d "$SUPERPOWERS_DIR/hooks" ]]; then
        cp -r "$SUPERPOWERS_DIR/hooks/"* "$CLAUDE_DIR/hooks/"
        echo -e "${GREEN}✓ Hooks installed${NC}"
    fi

    # Copy library
    if [[ -d "$SUPERPOWERS_DIR/lib" ]]; then
        cp -r "$SUPERPOWERS_DIR/lib/"* "$CLAUDE_DIR/lib/"
        echo -e "${GREEN}✓ Library files installed${NC}"
    fi

    # Create skills directory and link skills
    mkdir -p "$CLAUDE_DIR/skills"
    if [[ -d "$SUPERPOWERS_DIR/skills" ]]; then
        echo "Setting up skills..."
        for skill_dir in "$SUPERPOWERS_DIR/skills"/*; do
            if [[ -d "$skill_dir" ]]; then
                skill_name=$(basename "$skill_dir")
                ln -sf "../plugins/superpowers/skills/$skill_name" "$CLAUDE_DIR/skills/$skill_name" 2>/dev/null || true
            fi
        done
        echo -e "${GREEN}✓ Skills linked${NC}"
    fi

    # Create marketplace entry for easy installation
    mkdir -p "$CLAUDE_PLUGINS_DIR/marketplaces"
    cat > "$CLAUDE_PLUGINS_DIR/marketplaces/superpowers.json" << 'EOF'
{
  "name": "superpowers-marketplace",
  "url": "file:///data/data/com.termux/files/home/.claude/plugins/superpowers/.claude-plugin"
}
EOF

    echo ""
    echo -e "${GREEN}✅ Superpowers installed successfully!${NC}"
    echo ""
    echo -e "${BLUE}Available commands in Claude:${NC}"
    echo "  /superpowers:brainstorm    - Design refinement"
    echo "  /superpowers:write-plan    - Create implementation plan"
    echo "  /superpowers:execute-plan  - Execute plan in batches"
    echo ""
    echo -e "${BLUE}Or install as plugin:${NC}"
    echo "  /plugin marketplace add file://$HOME/.claude/plugins/superpowers/.claude-plugin"
    echo "  /plugin install superpowers@superpowers-marketplace"
    echo ""
    echo -e "${YELLOW}Skills: $CLAUDE_DIR/skills/${NC}"
    echo -e "${YELLOW}Agents: $CLAUDE_DIR/agents/${NC}"
    echo -e "${YELLOW}Commands: $CLAUDE_DIR/commands/${NC}"
else
    echo -e "${YELLOW}⚠️  Git not found. Skipping Superpowers installation.${NC}"
    echo -e "${YELLOW}    To install manually:${NC}"
    echo -e "${YELLOW}    git clone https://github.com/obra/superpowers.git ~/.claude/plugins/superpowers${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Get API keys:"
echo "   • GLM: https://open.bigmodel.cn/usercenter/apikeys"
echo "   • MiniMax: https://platform.minimax.io/"
echo ""
echo "2. Run claude-all to get started:"
echo "   claude-all"
echo ""
echo "3. Manage API keys via menu:"
echo "   claude-all 10"
echo ""
echo "4. Use skills in Claude:"
echo "   claude --help  # See available commands"
echo "   Skills are automatically available in Claude CLI"
echo ""
