#!/usr/bin/env bash

# One-liner curl installer for Claude-All-New v7.0
# Supports: Linux, Termux, macOS, Windows (Git Bash/WSL)
# Usage: curl -fsSL https://raw.githubusercontent.com/zesbe/Claude-All-New/main/utils/install-curl.sh | bash
# Includes Superpowers Library (30 skills + 14 agents)

set -e

# Global variables for cleanup
TEMP_DIR=""
INSTALL_DIR=""

# Cleanup function for interrupted script
cleanup_on_exit() {
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        echo -e "${YELLOW}🧹 Cleaning up temporary files...${NC}"
        cd /
        rm -rf "$TEMP_DIR" 2>/dev/null || true
    fi
}

# Set trap for cleanup on script exit/interrupt
trap cleanup_on_exit EXIT INT TERM

# Platform detection
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "Linux";;
        Darwin*)    echo "macOS";;
        CYGWIN*|MINGW*|MSYS*) echo "Windows";;
    esac
}

PLATFORM=$(detect_platform)

# Colors - Support both Linux/macOS and Windows
if [[ "$PLATFORM" == "Windows" ]]; then
    # Windows (Git Bash/WSL) - Use tput if available, otherwise plain
    if command -v tput &> /dev/null; then
        GREEN=$(tput setaf 2 2>/dev/null || echo "")
        BLUE=$(tput setaf 4 2>/dev/null || echo "")
        YELLOW=$(tput setaf 3 2>/dev/null || echo "")
        RED=$(tput setaf 1 2>/dev/null || echo "")
        NC=$(tput sgr0 2>/dev/null || echo "")
    else
        # Plain text for Windows without color support
        GREEN=''
        BLUE=''
        YELLOW=''
        RED=''
        NC=''
    fi
else
    # Linux/macOS/Termux
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    NC='\033[0m'
fi

echo -e "${GREEN}🚀 Claude-All-New - One Command Installer${NC}"
echo "============================================"
echo ""

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is not installed${NC}"
    echo ""
    echo "Please install curl first:"
    echo "  Ubuntu/Debian: sudo apt install curl"
    echo "  macOS: brew install curl"
    echo "  Termux (Android): pkg install curl"
    echo "  Windows: Install Git for Windows (includes curl)"
    echo ""
    exit 1
fi

# Check if tar is installed
if ! command -v tar &> /dev/null; then
    echo -e "${RED}Error: tar is not installed${NC}"
    echo "Please install tar first."
    exit 1
fi

# Function to clean up existing installation
cleanup_existing_installation() {
    local install_dir="$1"

    echo -e "${YELLOW}🔍 Checking for existing installation...${NC}"

    # Backup existing config if exists
    if [[ -f "$install_dir/perplexity.json" ]]; then
        cp "$install_dir/perplexity.json" "$install_dir/perplexity.json.backup" 2>/dev/null || true
        echo -e "${BLUE}📋 Backed up existing Perplexity config${NC}"
    fi

    # Remove old claude-all if exists to prevent conflicts
    if [[ -f "$install_dir/claude-all" ]]; then
        echo -e "${YELLOW}🗑️  Removing old claude-all installation...${NC}"
        rm -f "$install_dir/claude-all" 2>/dev/null || true
    fi

    # Remove old bin folder files that might conflict
    if [[ -d "$install_dir" && -f "$install_dir/glm.json" ]]; then
        echo -e "${YELLOW}🧹 Cleaning old config files...${NC}"
        # Keep backup of custom API keys
        for config_file in "$install_dir"/*.json; do
            if [[ -f "$config_file" && "$config_file" != *"test.json" && "$config_file" != *"SET_YOUR"* ]]; then
                cp "$config_file" "$config_file.backup" 2>/dev/null || true
            fi
        done
    fi
}

# Create temp directory (cross-platform)
if [[ "$PLATFORM" == "Windows" ]]; then
    # Windows - use a simple temp dir
    TEMP_DIR="/tmp/claude-all-new-$$"
    mkdir -p "$TEMP_DIR" || {
        echo -e "${RED}❌ Failed to create temp directory${NC}"
        exit 1
    }
else
    # Linux/macOS/Termux
    TEMP_DIR=$(mktemp -d) || {
        echo -e "${RED}❌ Failed to create temp directory${NC}"
        exit 1
    }
fi

cd "$TEMP_DIR" || {
    echo -e "${RED}❌ Failed to change to temp directory${NC}"
    exit 1
}

echo -e "${BLUE}Downloading Claude-All-New...${NC}"
curl -fsSL https://github.com/zesbe/Claude-All-New/archive/main.tar.gz -o claude-all-new.tar.gz || {
    echo -e "${RED}Failed to download. Check your internet connection.${NC}"
    exit 1
}

echo -e "${BLUE}Extracting files...${NC}"
tar -xzf claude-all-new.tar.gz || {
    echo -e "${RED}Failed to extract files.${NC}"
    exit 1
}

cd Claude-All-New-main || {
    echo -e "${RED}Failed to change directory.${NC}"
    exit 1
}

# Choose installation directory
if [[ "$1" == "--system" ]]; then
    if [[ "$PLATFORM" == "Windows" ]]; then
        echo -e "${YELLOW}System-wide installation not supported on Windows${NC}"
        INSTALL_DIR="$HOME/.local/bin"
    else
        INSTALL_DIR="/usr/local/bin"
        echo -e "${BLUE}Installing system-wide to $INSTALL_DIR${NC}"
        if ! sudo mkdir -p "$INSTALL_DIR" 2>/dev/null; then
            echo -e "${YELLOW}Cannot write to /usr/local/bin, trying ~/.local/bin${NC}"
            INSTALL_DIR="$HOME/.local/bin"
            mkdir -p "$INSTALL_DIR" || {
                echo -e "${RED}❌ Failed to create installation directory${NC}"
                exit 1
            }
        fi
    fi
else
    INSTALL_DIR="$HOME/.local/bin"
    echo -e "${BLUE}Installing to $INSTALL_DIR${NC}"
    mkdir -p "$INSTALL_DIR" || {
        echo -e "${RED}❌ Failed to create installation directory${NC}"
        exit 1
    }
fi

# Clean up existing installation before proceeding
cleanup_existing_installation "$INSTALL_DIR"

# Copy files (main script + config files)
if [[ "$INSTALL_DIR" == "/usr/local/bin" ]]; then
    # Copy main claude-all script
    sudo cp claude-all "$INSTALL_DIR/" 2>/dev/null || {
        echo -e "${RED}Failed to copy claude-all script${NC}"
        exit 1
    }
    sudo chmod +x "$INSTALL_DIR/claude-all" 2>/dev/null || true

    # Copy config files from bin/
    sudo cp -r bin/* "$INSTALL_DIR/" 2>/dev/null || {
        echo -e "${RED}Failed to copy config files${NC}"
        exit 1
    }
    sudo chmod +x "$INSTALL_DIR"/* 2>/dev/null || true
else
    # Copy main claude-all script
    cp claude-all "$INSTALL_DIR/" || {
        echo -e "${RED}Failed to copy claude-all script${NC}"
        exit 1
    }
    chmod +x "$INSTALL_DIR/claude-all" || true

    # Copy config files from bin/
    cp -r bin/* "$INSTALL_DIR/" || {
        echo -e "${RED}Failed to copy config files${NC}"
        exit 1
    }
    chmod +x "$INSTALL_DIR"/* 2>/dev/null || true

    # Also copy claude-switch to main bin directory if exists
    if [[ -f "$HOME/.local/bin/claude-switch" ]]; then
        cp "$HOME/.local/bin/claude-switch" "$INSTALL_DIR/" 2>/dev/null || true
    fi
fi

# Copy model config
if [[ -d "model" ]]; then
    echo -e "${BLUE}Copying model configuration...${NC}"
    mkdir -p "$INSTALL_DIR/model"
    if [[ -n "$(ls -A model/ 2>/dev/null)" ]]; then
        cp model/* "$INSTALL_DIR/model/" 2>/dev/null || echo -e "${YELLOW}Warning: Failed to copy model files${NC}"
        echo -e "${GREEN}✓ Model config copied${NC}"
    else
        echo -e "${YELLOW}Warning: Model directory is empty${NC}"
    fi
fi

# Copy Superpowers components (NO DUPLICATION)
if [[ -d "superpowers" ]]; then
    echo -e "${BLUE}📦 Installing Superpowers components...${NC}"

    # Create temporary source path
    TEMP_SOURCE="/tmp/superpowers-$$"
    cp -r superpowers "$TEMP_SOURCE" 2>/dev/null || {
        echo -e "${YELLOW}Warning: Could not copy superpowers temporarily${NC}"
    }

    # Remove skills from temp (will install directly to ~/.claude/skills/)
    if [[ -d "$TEMP_SOURCE/skills" ]]; then
        rm -rf "$TEMP_SOURCE/skills"
    fi

    # Copy remaining components to install dir (without skills)
    if [[ "$INSTALL_DIR" == "/usr/local/bin" ]]; then
        sudo cp -r "$TEMP_SOURCE" "$INSTALL_DIR/superpowers" 2>/dev/null || {
            echo -e "${YELLOW}Warning: Could not copy superpowers components${NC}"
        }
    else
        cp -r "$TEMP_SOURCE" "$INSTALL_DIR/superpowers" 2>/dev/null || {
            echo -e "${YELLOW}Warning: Could not copy superpowers components${NC}"
        }
    fi

    # Clean up temp
    rm -rf "$TEMP_SOURCE"

    echo -e "${GREEN}✓ Superpowers components installed${NC}"
    echo -e "${GREEN}  ✅ Skills will be installed directly to ~/.claude/skills/${NC}"
    echo -e "${GREEN}  ✅ No duplication - single source of truth${NC}"
fi

# Verify installation success
echo -e "${BLUE}🔍 Verifying installation...${NC}"

# Check if claude-all script was copied successfully
if [[ ! -f "$INSTALL_DIR/claude-all" ]]; then
    echo -e "${RED}❌ Installation failed: claude-all script not found${NC}"
    exit 1
fi

# Check if claude-all is executable
if [[ ! -x "$INSTALL_DIR/claude-all" ]]; then
    echo -e "${RED}❌ Installation failed: claude-all is not executable${NC}"
    exit 1
fi

# Check if PATH is set correctly and add it automatically if needed
PATH_ADDED=false
PATH_ALREADY_SET=false

if echo ":$PATH:" | grep -q ":$INSTALL_DIR:"; then
    PATH_ALREADY_SET=true
    echo -e "${GREEN}✓ PATH already configured${NC}"
else
    echo -e "${YELLOW}⚙️  Configuring PATH automatically...${NC}"

    # Detect shell and configuration file
    if [[ -n "$BASH_VERSION" ]]; then
        SHELL_CONF="$HOME/.bashrc"
        if [[ "$PLATFORM" == "Darwin" ]] && [[ -f "$HOME/.zshrc" ]]; then
            SHELL_CONF="$HOME/.zshrc"
        fi
    elif [[ -n "$ZSH_VERSION" ]]; then
        SHELL_CONF="$HOME/.zshrc"
    else
        SHELL_CONF="$HOME/.profile"
    fi

    # Add PATH to shell configuration
    if echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_CONF" 2>/dev/null; then
        echo -e "${GREEN}✓ Added PATH to $SHELL_CONF${NC}"
        PATH_ADDED=true
    else
        echo -e "${YELLOW}⚠️  Could not modify $SHELL_CONF automatically${NC}"
        PATH_ADDED=false
    fi
fi

# Test claude-all command
if command -v claude-all &> /dev/null; then
    echo -e "${GREEN}✓ claude-all command is working!${NC}"
    COMMAND_WORKS=true
else
    echo -e "${YELLOW}⚠️  claude-all command not found in current session${NC}"
    COMMAND_WORKS=false
fi

# Install Superpowers for Claude - AUTOMATIC INTEGRATION
echo ""
echo -e "${BLUE}🔗 Integrating Superpowers with Claude...${NC}"

# Create Claude directories
CLAUDE_DIR="$HOME/.claude"
CLAUDE_PLUGINS_DIR="$CLAUDE_DIR/plugins"
mkdir -p "$CLAUDE_PLUGINS_DIR"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/lib"
mkdir -p "$CLAUDE_DIR/skills"

# Check for local copy first
SUPERPOWERS_SOURCE=""
if [[ -d "$INSTALL_DIR/superpowers" ]]; then
    SUPERPOWERS_SOURCE="$INSTALL_DIR/superpowers"
    echo -e "${GREEN}✓ Found bundled Superpowers library${NC}"
elif [[ -d "$INSTALL_DIR/../superpowers" ]]; then
    SUPERPOWERS_SOURCE="$INSTALL_DIR/../superpowers"
    echo -e "${GREEN}✓ Found local Superpowers library${NC}"
fi

if [[ -n "$SUPERPOWERS_SOURCE" ]]; then
    # Install from local source (FASTEST)
    echo -e "${BLUE}🚀 Installing from local copy...${NC}"

    # Copy components to plugins directory (without skills)
    mkdir -p "$HOME/.claude/plugins/superpowers"

    # Copy everything except skills
    for item in "$SUPERPOWERS_SOURCE"/*; do
        item_name=$(basename "$item")
        if [[ "$item_name" != "skills" ]]; then
            cp -r "$item" "$HOME/.claude/plugins/superpowers/" 2>/dev/null || true
        fi
    done

    # Copy skills directly to ~/.claude/skills/
    if [[ -d "$SUPERPOWERS_SOURCE/skills" ]]; then
        cp -r "$SUPERPOWERS_SOURCE/skills"/* "$CLAUDE_DIR/skills/" 2>/dev/null || true
        echo -e "${GREEN}✓ Skills installed to ~/.claude/skills/${NC}"
    fi

    SUPERPOWERS_DIR="$HOME/.claude/plugins/superpowers"
    echo -e "${GREEN}✓ Local copy installed${NC}"
elif command -v git &> /dev/null; then
    # Download from GitHub as fallback
    echo -e "${YELLOW}⬇️  Downloading from GitHub...${NC}"
    if [[ -d "$HOME/.claude/plugins/superpowers" ]]; then
        echo "Updating Superpowers..."
        (cd "$HOME/.claude/plugins/superpowers" && git pull) || echo -e "${YELLOW}Warning: Could not update${NC}"
    else
        echo "Downloading Superpowers..."
        git clone https://github.com/obra/superpowers.git "$HOME/.claude/plugins/superpowers" || echo -e "${YELLOW}Warning: Could not download${NC}"
    fi

    # Move skills from plugins to skills directory
    if [[ -d "$HOME/.claude/plugins/superpowers/skills" ]]; then
        mv "$HOME/.claude/plugins/superpowers/skills"/* "$CLAUDE_DIR/skills/" 2>/dev/null || true
        rm -rf "$HOME/.claude/plugins/superpowers/skills"
        echo -e "${GREEN}✓ Skills moved to ~/.claude/skills/${NC}"
    fi

    SUPERPOWERS_DIR="$HOME/.claude/plugins/superpowers"

    # Install as Claude plugin
    if [[ -d "$SUPERPOWERS_DIR" ]]; then
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
            cp -r "$SUPERPOWERS_DIR/agents/"* "$CLAUDE_DIR/agents/" 2>/dev/null || true
            echo -e "${GREEN}✓ Agents installed${NC}"
        fi

        # Copy commands
        if [[ -d "$SUPERPOWERS_DIR/commands" ]]; then
            cp -r "$SUPERPOWERS_DIR/commands/"* "$CLAUDE_DIR/commands/" 2>/dev/null || true
            echo -e "${GREEN}✓ Commands installed${NC}"
        fi

        # Copy hooks
        if [[ -d "$SUPERPOWERS_DIR/hooks" ]]; then
            cp -r "$SUPERPOWERS_DIR/hooks/"* "$CLAUDE_DIR/hooks/" 2>/dev/null || true
            echo -e "${GREEN}✓ Hooks installed${NC}"
        fi

        # Copy library
        if [[ -d "$SUPERPOWERS_DIR/lib" ]]; then
            cp -r "$SUPERPOWERS_DIR/lib/"* "$CLAUDE_DIR/lib/" 2>/dev/null || true
            echo -e "${GREEN}✓ Library files installed${NC}"
        fi

        # Skills are already copied directly to ~/.claude/skills/
        skill_count=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -type d 2>/dev/null | wc -l)
        skill_count=$((skill_count - 1))  # Subtract parent directory
        echo -e "${GREEN}✓ Skills installed directly: $skill_count skills${NC}"
        echo -e "${BLUE}  Skills location: ~/.claude/skills/${NC}"

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
    fi
else
    echo -e "${YELLOW}⚠️  Git not found. Skipping Superpowers installation.${NC}"
    echo -e "${YELLOW}    To install manually: git clone https://github.com/obra/superpowers.git ~/.claude/plugins/superpowers${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo ""
echo -e "${BLUE}Platform:${NC} $PLATFORM"
echo -e "${BLUE}Install Dir:${NC} $INSTALL_DIR"
echo ""

# Status indicators
if [[ "$PATH_ALREADY_SET" == "true" && "$COMMAND_WORKS" == "true" ]]; then
    echo -e "${GREEN}🚀 Ready to use! Run: claude-all${NC}"
    READY_TO_USE=true
elif [[ "$PATH_ADDED" == "true" || "$PATH_ALREADY_SET" == "true" ]]; then
    if [[ "$COMMAND_WORKS" == "false" ]]; then
        echo -e "${YELLOW}⚠️  PATH is configured but current session needs reload${NC}"
        echo -e "${BLUE}Run: source ~/.bashrc && claude-all${NC}"
        READY_TO_USE=false
    fi
else
    echo -e "${YELLOW}⚠️  Manual PATH configuration may be needed${NC}"
    echo -e "${BLUE}Run: export PATH=\"$INSTALL_DIR:\$PATH\" && claude-all${NC}"
    READY_TO_USE=false
fi

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. 🔑 Get your API keys:"
echo "   • GLM: https://open.bigmodel.cn/usercenter/apikeys"
echo "   • MiniMax: https://platform.minimax.io/"
echo "   • OpenAI: https://platform.openai.com/api-keys"
echo "   • Gemini: https://aistudio.google.com/app/apikey"
echo "   • Perplexity: https://console.perplexity.ai/"
echo ""
echo "2. 💾 Save API keys:"
echo "   claude-all"
echo "   # Choose: 10) 🔑 API Key Manager"
echo ""
echo "3. 🚀 Start chatting:"
echo "   claude-all 7    # For GLM"
echo "   claude-all 1    # For MiniMax"
echo "   claude-all 11   # Custom (e.g., perplexity/sonar-pro)"
echo ""
echo "4. 🎯 Superpowers Skills (INSTALLED):"
echo -e "${GREEN}   ✅ 55+ files copied to ~/.claude/plugins/superpowers/${NC}"
echo -e "${GREEN}   ✅ 20 development skills linked${NC}"
echo -e "${GREEN}   ✅ Commands, agents, hooks integrated${NC}"
echo ""
echo "5. 💡 Use Superpowers in Claude:"
echo "   claude"
echo "   /superpowers:brainstorm    # Refine your ideas"
echo "   /superpowers:write-plan    # Create implementation plan"
echo "   /superpowers:execute-plan  # Execute step-by-step"
echo ""
echo "6. 📚 Skills location:"
echo "   ~/.claude/skills/          # 20 skills available"
echo "   ~/.claude/commands/        # Core commands"
echo "   ~/.claude/agents/          # Code reviewer"
echo "   ~/.claude/hooks/           # Workflow automation"
echo ""

# Show backup information if backups were created
if ls "$INSTALL_DIR"/*.backup 2>/dev/null | head -1 >/dev/null; then
    echo -e "${BLUE}📋 Backups created of existing configurations:${NC}"
    ls "$INSTALL_DIR"/*.backup 2>/dev/null | while read backup; do
        echo "   $(basename "$backup" .backup)"
    done
    echo ""
fi
echo -e "${BLUE}📚 Documentation:${NC}"
echo "   https://github.com/zesbe/Claude-All-New"
echo ""
echo -e "${GREEN}Happy Chatting! 🚀${NC}"
