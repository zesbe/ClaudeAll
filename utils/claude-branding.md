# Claude-All Branding Guide

## 🎯 Lokasi File yang Bisa Diedit

### 1. Main Script
```bash
~/.local/bin/claude-all
```

**Edit di line sekitar:**
- Line 60: `echo -e "${BLUE}Claude Code Multi-Model Launcher${NC}"`
- Line 65: Menu items text
- Line 286: System prompt text

### 2. Model Display Names
Edit files di `~/.local/bin/model/*.json`:
```json
{
  "provider": "Custom Name",
  "model": "custom-model",
  "display_name": "Your Brand Name"
}
```

### 3. ASCII Art Banner
Tambah di awal claude-all script:
```bash
cat << 'EOF'
${CYAN}
╔════════════════════════════════════════╗
║                                          ║
║    █▀▀ █ █ █▀▀ █▀▀ █▀▀   █▀█ █▀▀ █▀▀    ║
║    █▀▀ █▀▀ █▀  █▀  ▀▀█   █▀▀ █▀  █▀     ║
║    ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀   ▀   ▀▀▀ ▀▀▀    ║
║                                          ║
║       MULTI-PROVIDER AI LAUNCHER        ║
╚════════════════════════════════════════╝
${NC}
EOF
```

### 4. Custom ASCII Art Generator
```python
# Python script untuk generate ASCII art
# Save sebagai generate-art.py
from pyfiglet import Figlet
import sys

text = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Claude-All"
font = Figlet(font='slant')

print(font.renderText(text))
```

Usage:
```bash
python3 generate-art.py "YOUR BRAND"
```

### 5. Color Customization
Ganti color variables di claude-all:
```bash
# Line sekitar 19-23
GREEN='\033[0;32m'
BLUE='\033[0;34m'      # Ganti ke brand color
YELLOW='\033[1;33m'     # Ganti ke accent color
RED='\033[0;31m'
PURPLE='\033[0;35m'     # Tambah color baru
CYAN='\033[0;36m'       # Tambah color baru
```

## 🎭 Contoh Branding

### Example 1: "AI-Master"
```bash
# Ubah nama executable
mv ~/.local/bin/claude-all ~/.local/bin/ai-master

# Edit banner
echo -e "${PURPLE}┌─────────────────────────────────┐${NC}"
echo -e "${PURPLE}│        AI-MASTER v7.0          │${NC}"
echo -e "${PURPLE}│   Advanced AI Tools Suite      │${NC}"
echo -e "${PURPLE}└─────────────────────────────────┘${NC}"
```

### Example 2: "Neural-CLI"
```bash
# Dengan ASCII art
echo -e "${CYAN}"
echo "  _   _   _   _   _   _   _   _"
echo " / \ / \ / \ / \ / \ / \ / \ / \ "
echo "| N | E | U | R | A | L | - | C | L | I |"
echo " \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/"
echo "${NC}"
```

### Example 3: Custom Prompt
```bash
# Edit system prompt
local system_prompt="You are ALEX, an advanced AI assistant powered by $model_name. Always respond professionally and helpfully."
```

## ⚠️ Peringatan

### Yang TIDAK Boleh Diedit:
- API endpoint configurations
- Core logic untuk model switching
- Authentication flows
- Error handling mechanisms

### Yang BOLEH Diedit:
- Display text dan banners
- Color schemes
- ASCII art
- System prompts
- Command names

### Backup Selalu!
```bash
# Sebelum edit
cp ~/.local/bin/claude-all ~/.local/bin/claude-all.backup

# Untuk restore
cp ~/.local/bin/claude-all.backup ~/.local/bin/claude-all
```

## 🛠️ Tools yang Bisa Digunakan

1. **ASCII Art Generator**
   - Online: https://patorjk.com/software/taag/
   - Python: pip install pyfiglet

2. **Color Picker**
   - https://bash-prompt-generator.org/
   - https://quickref.me/bash-colors

3. **Testing**
   ```bash
   # Test output di terminal
   echo -e "\033[0;31mRed Text\033[0m"
   echo -e "\033[1;33mBold Yellow\033[0m"
   ```

## 📝 Template Custom Brand

```bash
#!/usr/bin/env bash
# Template untuk custom branded claude-all

# === CONFIGURATION ===
BRAND_NAME="YOUR-BRAND"
BRAND_COLOR="\033[0;35m"  # Purple
ACCENT_COLOR="\033[0;33m" # Yellow

# === BANNER ===
echo -e "${BRAND_COLOR}"
cat << 'EOF'
╔════════════════════════════════════════╗
║                                          ║
║           YOUR-BRAND AI TOOLS            ║
║         Advanced AI Interface            ║
║                                          ║
╚════════════════════════════════════════╝
EOF
echo -e "${NC}"
```