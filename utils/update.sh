#!/usr/bin/env bash

# Claude-All-New Updater
# Safely updates all files while preserving user data

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get installation directory
INSTALL_DIR="$HOME/.local/bin"
if [[ ! -f "$INSTALL_DIR/claude-all" ]]; then
    INSTALL_DIR="/usr/local/bin"
    if [[ ! -f "$INSTALL_DIR/claude-all" ]]; then
        echo -e "${RED}Error: Claude-All-New not found. Please install first.${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}🔄 Claude-All-New Updater${NC}"
echo "=================================="
echo -e "${BLUE}Installation directory: $INSTALL_DIR${NC}"
echo

# Get current version
CURRENT_VERSION=""
if [[ -f "$INSTALL_DIR/VERSION" ]]; then
    CURRENT_VERSION=$(cat "$INSTALL_DIR/VERSION" | grep VERSION | cut -d'"' -f2)
    echo -e "${YELLOW}Current version: $CURRENT_VERSION${NC}"
else
    echo -e "${YELLOW}Current version: Unknown${NC}"
fi

# Download latest version
echo -e "${BLUE}Downloading latest version...${NC}"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download files
if command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -q"
elif command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -fsSL"
else
    echo -e "${RED}Error: wget or curl required${NC}"
    exit 1
fi

# Get repository files
REPO_URL="https://raw.githubusercontent.com/zesbe/Claude-All-New/main"

# Download main script
echo -e "${BLUE}Downloading main script...${NC}"
$DOWNLOAD_CMD "$REPO_URL/claude-all" -O claude-new || {
    echo -e "${RED}Failed to download claude-all${NC}"
    exit 1
}

# Download version file
$DOWNLOAD_CMD "$REPO_URL/VERSION" -O VERSION || {
    echo -e "${RED}Failed to download VERSION${NC}"
    exit 1
}

# Get latest version
LATEST_VERSION=$(cat VERSION | grep VERSION | cut -d'"' -f2)
echo -e "${GREEN}Latest version: $LATEST_VERSION${NC}"

# Check if update needed
if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo -e "${GREEN}✓ Already up to date!${NC}"
    cd /
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Backup user data before update
echo -e "${BLUE}Creating backup...${NC}"
BACKUP_DIR="$HOME/.claude-all-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup API keys and sensitive configs
if [[ -f "$HOME/.config/claude-all/api_keys.json" ]]; then
    cp "$HOME/.config/claude-all/api_keys.json" "$BACKUP_DIR/" 2>/dev/null || true
fi

# Backup model configs with user modifications
if [[ -d "$INSTALL_DIR/model" ]]; then
    mkdir -p "$BACKUP_DIR/model"
    cp -r "$INSTALL_DIR/model/"* "$BACKUP_DIR/model/" 2>/dev/null || true
fi

# Download updated files
echo -e "${BLUE}Downloading updated files...${NC}"

# Download all JSON model configs
mkdir -p bin
for file in antigravity.json gemini.json openai.json glm.json minimax.json groq.json xai.json openrouter.json ollama.json cohere.json deepseek.json mistral.json moonshot.json perplexity.json qwen.json agentrouter.json test.json; do
    echo -e "${YELLOW}  Downloading $file...${NC}"
    $DOWNLOAD_CMD "$REPO_URL/bin/$file" -O "bin/$file" || {
        echo -e "${RED}Failed to download $file${NC}"
    }
done

# Download utility scripts
$DOWNLOAD_CMD "$REPO_URL/bin/api-manager" -O bin/api-manager || {
    echo -e "${RED}Failed to download api-manager${NC}"
}

# Install updated files
echo -e "${BLUE}Installing updates...${NC}"

# Backup current executable
if [[ -f "$INSTALL_DIR/claude-all" ]]; then
    cp "$INSTALL_DIR/claude-all" "$INSTALL_DIR/claude-all.backup"
fi

# Install new files
chmod +x claude-new
mv claude-new "$INSTALL_DIR/claude-all"
chmod +x bin/api-manager
cp -r bin/* "$INSTALL_DIR/"
cp VERSION "$INSTALL_DIR/"

# Restore user customizations if they exist
echo -e "${BLUE}Restoring customizations...${NC}"

# Check if user had custom model files and merge them
if [[ -d "$BACKUP_DIR/model" ]]; then
    for backup_file in "$BACKUP_DIR/model"/*.json; do
        if [[ -f "$backup_file" ]]; then
            filename=$(basename "$backup_file")
            if [[ -f "$INSTALL_DIR/model/$filename" ]]; then
                # Compare and ask user if they want to keep their version
                echo -e "${YELLOW}Found customized model config: $filename${NC}"
                echo -e "${YELLOW}Keeping your customized version${NC}"
                # Could add more sophisticated merge logic here
            fi
        fi
    done
fi

# Set permissions
chmod +x "$INSTALL_DIR"/* 2>/dev/null || true

# Cleanup
echo -e "${BLUE}Cleaning up...${NC}"
cd /
rm -rf "$TEMP_DIR"

echo
echo -e "${GREEN}✓ Update completed successfully!${NC}"
echo -e "${GREEN}  Updated from $CURRENT_VERSION to $LATEST_VERSION${NC}"
echo -e "${YELLOW}  Backup saved at: $BACKUP_DIR${NC}"
echo
echo -e "${BLUE}Run 'claude-all' to use the updated version${NC}"