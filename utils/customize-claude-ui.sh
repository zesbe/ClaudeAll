#!/usr/bin/env bash

# Script to customize Claude-All appearance
# Change banners, colors, and text

set -e

# Colors
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
CLAUDE_ALL="$HOME/.local/bin/claude-all"
CONFIG_DIR="$HOME/.config/claude-all"
BANNER_FILE="$CONFIG_DIR/banner.txt"
THEME_FILE="$CONFIG_DIR/theme.conf"

echo -e "${PURPLE}🎨 Claude-All UI Customizer${NC}"
echo "=============================="
echo ""

# Create config directory
mkdir -p "$CONFIG_DIR"

# Function to create custom banner
create_banner() {
    local title="$1"
    local subtitle="$2"

    cat << EOF > "$BANNER_FILE"
${CYAN}╔─────────────────────────────────────────────────────╗
║                                                     ║
║  ${title}
║  ${subtitle}
║                                                     ║
╚─────────────────────────────────────────────────────╝${NC}
EOF
}

# Function to customize colors
customize_colors() {
    local primary="$1"
    local secondary="$2"
    local accent="$3"

    cat << EOF > "$THEME_FILE"
PRIMARY_COLOR='$primary'
SECONDARY_COLOR='$secondary'
ACCENT_COLOR='$accent'
EOF
}

echo -e "${BLUE}Choose customization:${NC}"
echo "1) 🚀 Tech Theme"
echo "2) 🌸 Anime Theme"
echo "3) 🎮 Gaming Theme"
echo "4) 💼 Professional Theme"
echo "5) 🎨 Custom Banner"
echo "6) 🎭 Custom Colors"
echo ""

read -p "Select option (1-6): " choice

case $choice in
    1)
        create_banner "⚡ AI Multi-Tool CLI" "30+ Providers • 100+ Models • Superpowers"
        customize_colors '$CYAN' '$BLUE' '$YELLOW'
        echo -e "${GREEN}✅ Tech theme applied${NC}"
        ;;
    2)
        create_banner "🌸 Kawaii AI-chan" "✨ Sugoi AI Tools • Senpai~"
        customize_colors '$PURPLE' '$YELLOW' '$CYAN'
        echo -e "${GREEN}✅ Anime theme applied${NC}"
        ;;
    3)
        create_banner "🎮 GAME AI MODE" "||| LOADING AI SKILLS... |||"
        customize_colors '$RED' '$YELLOW' '$GREEN'
        echo -e "${GREEN}✅ Gaming theme applied${NC}"
        ;;
    4)
        create_banner "📊 Professional AI Suite" "Enterprise-Grade AI Tools"
        customize_colors '$BLUE' '$GREEN' '$NC'
        echo -e "${GREEN}✅ Professional theme applied${NC}"
        ;;
    5)
        echo -e "${YELLOW}Enter your custom banner:${NC}"
        echo "Format: Line1|Line2|Line3"
        read -p "> " custom_text
        IFS='|' read -ra LINES <<< "$custom_text"
        create_banner "${LINES[0]}" "${LINES[1]}"
        echo -e "${GREEN}✅ Custom banner created${NC}"
        ;;
    6)
        echo -e "${YELLOW}Enter color codes (bash colors):${NC}"
        echo "Options: \\033[0;31m (Red), \\033[0;32m (Green), \\033[0;34m (Blue), etc."
        read -p "Primary color: " primary
        read -p "Secondary color: " secondary
        read -p "Accent color: " accent
        customize_colors "$primary" "$secondary" "$accent"
        echo -e "${GREEN}✅ Custom colors applied${NC}"
        ;;
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

# Apply customizations to claude-all
echo ""
echo -e "${BLUE}Applying customizations...${NC}"

# Backup original
cp "$CLAUDE_ALL" "$CLAUDE_ALL.backup.$(date +%Y%m%d)"

# Create modified version with custom theme
cat << 'EOF' > /tmp/claude-all-modified.sh
#!/usr/bin/env bash

# Load custom theme
CONFIG_DIR="$HOME/.config/claude-all"
if [[ -f "$CONFIG_DIR/theme.conf" ]]; then
    source "$CONFIG_DIR/theme.conf"
else
    PRIMARY_COLOR='\033[0;34m'  # Blue
    SECONDARY_COLOR='\033[0;36m'  # Cyan
    ACCENT_COLOR='\033[0;33m'  # Yellow
fi

# Display custom banner
if [[ -f "$CONFIG_DIR/banner.txt" ]]; then
    cat "$CONFIG_DIR/banner.txt"
    echo ""
else
    # Default banner
    echo -e "${PRIMARY_COLOR}=====================================${NC}"
    echo -e "${SECONDARY_COLOR}     Claude-All Multi-Model Tool${NC}"
    echo -e "${PRIMARY_COLOR}=====================================${NC}"
    echo ""
fi
EOF

# Insert theme loading into claude-all
sed -i "/^set -e$/r /tmp/claude-all-modified.sh" "$CLAUDE_ALL"

# Clean up
rm -f /tmp/claude-all-modified.sh

echo ""
echo -e "${GREEN}🎉 Customization Complete!${NC}"
echo "=========================="
echo ""
echo "To test:"
echo "  claude-all"
echo ""
echo "To restore original:"
echo "  cp ~/.local/bin/claude-all.backup.YYYYMMDD ~/.local/bin/claude-all"
echo ""