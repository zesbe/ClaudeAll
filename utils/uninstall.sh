#!/usr/bin/env bash

# Claude-All-New Uninstaller
# Cross-platform: Linux, Termux, macOS, Windows (Git Bash/WSL)

# Platform detection
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "Linux";;
        Darwin*)    echo "macOS";;
        CYGWIN*|MINGW*|MSYS*) echo "Windows";;
        *)          echo "Linux";;
    esac
}

PLATFORM=$(detect_platform)

# Colors
if [[ "$PLATFORM" == "Windows" ]]; then
    if command -v tput &> /dev/null; then
        GREEN=$(tput setaf 2 2>/dev/null || echo "")
        BLUE=$(tput setaf 4 2>/dev/null || echo "")
        RED=$(tput setaf 1 2>/dev/null || echo "")
        YELLOW=$(tput setaf 3 2>/dev/null || echo "")
        NC=$(tput sgr0 2>/dev/null || echo "")
    else
        GREEN='' BLUE='' RED='' YELLOW='' NC=''
    fi
else
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
fi

# Portable home directory
if [[ -n "$HOME" ]]; then
    USER_HOME="$HOME"
elif [[ -n "$USERPROFILE" ]]; then
    USER_HOME="$USERPROFILE"
else
    USER_HOME="$HOME"
fi

INSTALL_DIR="$USER_HOME/.local/bin"

echo -e "${RED}╔════════════════════════════════════════╗${NC}"
echo -e "${RED}║   Claude-All-New Uninstaller           ║${NC}"
echo -e "${RED}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Platform:${NC} $PLATFORM"
echo -e "${YELLOW}Install Dir:${NC} $INSTALL_DIR"
echo ""

# Check if installed
if [[ ! -f "$INSTALL_DIR/claude-all" ]]; then
    echo -e "${YELLOW}Claude-All-New is not installed in $INSTALL_DIR${NC}"
    echo ""
    read -p "Check another location? (y/N): " check_other
    if [[ "$check_other" =~ ^[Yy]$ ]]; then
        read -p "Enter install directory: " INSTALL_DIR
        if [[ ! -f "$INSTALL_DIR/claude-all" ]]; then
            echo -e "${RED}Not found in $INSTALL_DIR${NC}"
            exit 1
        fi
    else
        exit 0
    fi
fi

echo -e "${BLUE}Found Claude-All-New installation:${NC}"
echo ""

# List files to remove
FILES_TO_REMOVE=(
    "$INSTALL_DIR/claude-all"
    "$INSTALL_DIR/api-manager"
)

# Check for model directory
if [[ -d "$INSTALL_DIR/model" ]]; then
    FILES_TO_REMOVE+=("$INSTALL_DIR/model")
fi

echo "Files to remove:"
for file in "${FILES_TO_REMOVE[@]}"; do
    if [[ -e "$file" ]]; then
        echo -e "  ${RED}✗${NC} $file"
    fi
done
echo ""

# API Keys
API_KEY_FILES=(
    "$USER_HOME/.glm_api_key"
    "$USER_HOME/.minimax_api_key"
    "$USER_HOME/.openai_api_key"
    "$USER_HOME/.gemini_api_key"
    "$USER_HOME/.xai_api_key"
    "$USER_HOME/.groq_api_key"
)

FOUND_KEYS=()
for keyfile in "${API_KEY_FILES[@]}"; do
    if [[ -f "$keyfile" ]]; then
        FOUND_KEYS+=("$keyfile")
    fi
done

if [[ ${#FOUND_KEYS[@]} -gt 0 ]]; then
    echo -e "${YELLOW}Found API key files:${NC}"
    for keyfile in "${FOUND_KEYS[@]}"; do
        echo -e "  ${YELLOW}🔑${NC} $keyfile"
    done
    echo ""
fi

# Confirmation
echo -e "${RED}⚠️  This action cannot be undone!${NC}"
echo ""
read -p "Remove Claude-All-New? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

# Remove program files
echo -e "${BLUE}Removing program files...${NC}"
for file in "${FILES_TO_REMOVE[@]}"; do
    if [[ -e "$file" ]]; then
        rm -rf "$file" 2>/dev/null && echo -e "  ${GREEN}✓${NC} Removed: $file" || echo -e "  ${RED}✗${NC} Failed: $file"
    fi
done

# Ask about API keys
if [[ ${#FOUND_KEYS[@]} -gt 0 ]]; then
    echo ""
    read -p "Also remove API key files? (y/N): " remove_keys

    if [[ "$remove_keys" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Removing API key files...${NC}"
        for keyfile in "${FOUND_KEYS[@]}"; do
            rm -f "$keyfile" 2>/dev/null && echo -e "  ${GREEN}✓${NC} Removed: $keyfile" || echo -e "  ${RED}✗${NC} Failed: $keyfile"
        done
    else
        echo -e "${GREEN}✓${NC} API keys preserved"
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Uninstall Complete!                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Claude-All-New has been removed from your system."
echo ""
echo -e "${BLUE}To reinstall:${NC}"
echo "  curl -fsSL https://raw.githubusercontent.com/zesbe/Claude-All-New/main/install-curl.sh | bash"
echo ""
