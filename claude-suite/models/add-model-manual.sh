#!/usr/bin/env bash

# Add Model Manual - Tambah Model Baru ke Claude-All
# Cara manual tanpa bantuan AI

set -e

# Ensure tput is available for colors
if ! command -v tput &> /dev/null; then
    # Try to install ncurses-utils (Termux)
    if command -v pkg &> /dev/null && [[ "$PLATFORM" != "Windows" ]]; then
        echo -e "${YELLOW}Installing ncurses-utils for color support...${NC}" >&2
        pkg install -y ncurses-utils &>/dev/null || true
    fi
fi

# Colors with terminal detection
if [[ -t 1 ]] && command -v tput &> /dev/null; then
    # Use tput for better compatibility
    GREEN=$(tput setaf 2 2>/dev/null || echo "")
    BLUE=$(tput setaf 4 2>/dev/null || echo "")
    YELLOW=$(tput setaf 3 2>/dev/null || echo "")
    RED=$(tput setaf 1 2>/dev/null || echo "")
    CYAN=$(tput setaf 6 2>/dev/null || echo "")
    BOLD=$(tput bold 2>/dev/null || echo "")
    NC=$(tput sgr0 2>/dev/null || echo "")
else
    # No color support
    GREEN=''
    BLUE=''
    YELLOW=''
    RED=''
    CYAN=''
    BOLD=''
    NC=''
fi

# Configuration
# Detect platform and set temp directory
if [[ "$(uname -s)" == "CYGWIN"* ]] || [[ "$(uname -s)" == "MINGW"* ]] || [[ "$(uname -s)" == "MSYS"* ]]; then
    PLATFORM="Windows"
    TEMP_FILE="$TEMP/claude-model.json"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux - use HOME directory for temp
    PLATFORM="Termux"
    TEMP_FILE="$HOME/.local/tmp/claude-model.json"
    mkdir -p "$(dirname "$TEMP_FILE")"
else
    PLATFORM="Unix"
    # Check if /tmp is writable
    if [[ -w "/tmp" ]]; then
        TEMP_FILE="/tmp/claude-model.json"
    else
        # Fallback to HOME
        TEMP_FILE="$HOME/.local/tmp/claude-model.json"
        mkdir -p "$(dirname "$TEMP_FILE")"
    fi
fi

# Get script directory
if command -v realpath &> /dev/null; then
    SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

MODEL_DIR="$SCRIPT_DIR/model"

# Preset templates for common providers
declare -A PRESET_TEMPLATES
PRESET_TEMPLATES["perplexity"]='{
    "provider_name": "Perplexity AI",
    "description": "Search-powered AI",
    "api_base": "https://api.perplexity.ai/",
    "model": "llama-3.1-sonar-small-128k-online",
    "api_key": "pplx-xxxxxxxx",
    "docs": "https://docs.perplexity.ai/api-reference/chat-completions"
}'

PRESET_TEMPLATES["mistral"]='{
    "provider_name": "Mistral AI",
    "description": "European AI models",
    "api_base": "https://api.mistral.ai/v1/",
    "model": "mistral-large-latest",
    "api_key": "xxxxxxxx",
    "docs": "https://docs.mistral.ai/api/"
}'

PRESET_TEMPLATES["cohere"]='{
    "provider_name": "Cohere",
    "description": "Enterprise AI models",
    "api_base": "https://api.cohere.ai/v1/",
    "model": "command-r-plus",
    "api_key": "xxxxxxxx",
    "docs": "https://docs.cohere.com/reference/chat"
}'

PRESET_TEMPLATES["anthropic"]='{
    "provider_name": "Anthropic",
    "description": "Claude API Direct",
    "api_base": "https://api.anthropic.com/v1/messages",
    "model": "claude-3-5-sonnet-20241022",
    "api_key": "sk-ant-api03-xxxxxxxx",
    "docs": "https://docs.anthropic.com/en/api/messages"
}'

PRESET_TEMPLATES["azure-openai"]='{
    "provider_name": "Azure OpenAI",
    "description": "Microsoft Azure OpenAI",
    "api_base": "https://your-resource.openai.azure.com/",
    "model": "gpt-4",
    "api_key": "xxxxxxxx",
    "api_version": "2024-02-15-preview",
    "docs": "https://learn.microsoft.com/en-us/azure/ai-services/openai/reference"
}'

PRESET_TEMPLATES["together"]='{
    "provider_name": "Together AI",
    "description": "Open Source Models",
    "api_base": "https://api.together.xyz/v1/",
    "model": "meta-llama/Llama-3.1-8B-Instruct-Turbo",
    "api_key": "xxxxxxxx",
    "docs": "https://docs.together.ai/reference/chat-completions"
}'

PRESET_TEMPLATES["fireworks"]='{
    "provider_name": "Fireworks AI",
    "description": "Fast Inference",
    "api_base": "https://api.fireworks.ai/v1/",
    "model": "accounts/fireworks/models/llama-v3p1-8b-instruct",
    "api_key": "xxxxxxxx",
    "docs": "https://readme.fireworks.ai/docs/chat-completions"
}'

# Functions
clear_screen() {
    clear
}

show_header() {
    clear_screen
    printf "%s=========================================%s\n" "${BOLD}${GREEN}" "${NC}"
    printf "%s     Add Model Manual ke Claude-All     %s\n" "${BOLD}${GREEN}" "${NC}"
    printf "%s=========================================%s\n" "${BOLD}${GREEN}" "${NC}"
    echo ""
}

show_menu() {
    echo -e "${BOLD}${BLUE}Pilih Cara Tambah Model:${NC}"
    echo ""
    printf "1) %sPake Template Siap Pakai%s (perplexity, mistral, dll)\n" "$YELLOW" "$NC"
    printf "2) %sBuat Manual Dari Awal%s (custom provider)\n" "$YELLOW" "$NC"
    printf "3) %sEdit Model Yang Ada%s\n" "$YELLOW" "$NC"
    printf "4) %sList Semua Model%s\n" "$YELLOW" "$NC"
    printf "5) %sHapus Model%s\n" "$YELLOW" "$NC"
    printf "6) %sBackup Model Config%s\n" "$YELLOW" "$NC"
    printf "0) %sKeluar%s\n" "$RED" "$NC"
    echo ""
}

show_template_menu() {
    echo -e "${BOLD}${BLUE}Pilih Provider Template:${NC}"
    echo ""
    echo "1) Perplexity AI (Search AI)"
    echo "2) Mistral AI (European AI)"
    echo "3) Cohere (Enterprise AI)"
    echo "4) Anthropic (Claude Direct)"
    echo "5) Azure OpenAI (Microsoft)"
    echo "6) Together AI (Open Source)"
    echo "7) Fireworks AI (Fast AI)"
    echo "8) Lihat semua template"
    echo "0) Kembali"
    echo ""
}

list_models() {
    clear_screen
    echo -e "${BOLD}${BLUE}Daftar Model Claude-All:${NC}"
    echo ""

    echo -e "${YELLOW}Model Bawaan:${NC}"
    echo "1) MiniMax (Direct Anthropic)"
    echo "2) Google Gemini (API Key)"
    echo "3) Google Gemini (OAuth)"
    echo "4) OpenAI (API Key)"
    echo "5) OpenAI (OAuth)"
    echo "6) xAI / Grok"
    echo "7) ZhipuAI / GLM"
    echo "8) Groq"
    echo "9) Ollama (Local)"
    echo ""

    echo -e "${YELLOW}Model Custom:${NC}"
    local count=10
    local found_custom=false

    for json_file in "$MODEL_DIR"/*.json; do
        if [[ -f "$json_file" ]]; then
            local filename=$(basename "$json_file" .json)

            # Skip default models
            case "$filename" in
                "glm"|"groq"|"minimax"|"openai"|"gemini"|"xai"|"ollama")
                    continue
                    ;;
            esac

            found_custom=true

            # Parse JSON if jq available
            if command -v jq &> /dev/null; then
                local provider=$(jq -r '.provider_name // "Unknown"' "$json_file" 2>/dev/null)
                local description=$(jq -r '.description // ""' "$json_file" 2>/dev/null)
                local model=$(jq -r '.model // ""' "$json_file" 2>/dev/null)

                echo "$count) $provider"
                [[ -n "$description" ]] && echo "   Deskripsi: $description"
                [[ -n "$model" ]] && echo "   Model: $model"
            else
                echo "$count) $filename"
            fi
            echo ""
            ((count++))
        fi
    done

    if [[ "$found_custom" == false ]]; then
        echo -e "${RED}Belum ada model custom${NC}"
        echo ""
    fi

    echo -e "${CYAN}Total: $(($count - 10)) model custom${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

create_from_template() {
    while true; do
        show_template_menu
        read -p "Pilihan [0-8]: " choice

        case $choice in
            1) template_key="perplexity"; break ;;
            2) template_key="mistral"; break ;;
            3) template_key="cohere"; break ;;
            4) template_key="anthropic"; break ;;
            5) template_key="azure-openai"; break ;;
            6) template_key="together"; break ;;
            7) template_key="fireworks"; break ;;
            8)
                clear_screen
                echo -e "${BOLD}${BLUE}Semua Template:${NC}"
                echo ""
                for key in "${!PRESET_TEMPLATES[@]}"; do
                    echo -e "${YELLOW}$key:${NC}"
                    if command -v jq &> /dev/null; then
                        echo "${PRESET_TEMPLATES[$key]}" | jq . 2>/dev/null || echo "${PRESET_TEMPLATES[$key]}"
                    else
                        echo "${PRESET_TEMPLATES[$key]}"
                    fi
                    echo ""
                done
                read -p "Press Enter to continue..."
                continue
                ;;
            0) return ;;
            *)
                echo -e "${RED}Pilihan tidak valid!${NC}"
                sleep 1
                continue
                ;;
        esac
    done

    # Get template
    local template_json="${PRESET_TEMPLATES[$template_key]}"

    # Parse provider name for filename
    local provider_name
    if command -v jq &> /dev/null; then
        provider_name=$(echo "$template_json" | jq -r '.provider_name' 2>/dev/null)
    else
        provider_name=$template_key
    fi

    # Create filename
    local filename=$(echo "$provider_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    local json_file="$MODEL_DIR/${filename}.json"

    clear_screen
    echo -e "${BOLD}${BLUE}Edit Template: $provider_name${NC}"
    echo ""
    echo -e "${YELLOW}File: $json_file${NC}"
    echo ""
    echo -e "${CYAN}Tips: Edit nilai yang diperlukan, lalu save (Ctrl+O) dan exit (Ctrl+X)${NC}"
    echo ""

    # Create temp file with template
    echo "$template_json" > "$TEMP_FILE"

    # Open in nano
    if command -v nano &> /dev/null; then
        nano "$TEMP_FILE"
    elif command -v vim &> /dev/null; then
        vim "$TEMP_FILE"
    else
        echo -e "${RED}Error: No text editor found${NC}"
        echo "Install nano: pkg install nano"
        rm -f "$TEMP_FILE"
        return
    fi

    # Validate JSON
    if command -v jq &> /dev/null; then
        if ! jq . "$TEMP_FILE" > /dev/null 2>&1; then
            echo -e "${RED}Error: JSON tidak valid!${NC}"
            read -p "Coba lagi? [y/N]: " retry
            if [[ "$retry" =~ ^[Yy]$ ]]; then
                create_from_template
                return
            fi
            rm -f "$TEMP_FILE"
            return
        fi

        # Format JSON
        jq . "$TEMP_FILE" > "$TEMP_FILE.formatted" && mv "$TEMP_FILE.formatted" "$TEMP_FILE"
    fi

    # Save to model directory
    cp "$TEMP_FILE" "$json_file"
    rm -f "$TEMP_FILE"

    echo ""
    echo -e "${GREEN}✅ Model berhasil ditambahkan!${NC}"
    echo -e "${YELLOW}File: $json_file${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

create_manual() {
    clear_screen
    echo -e "${BOLD}${BLUE}Buat Model Manual${NC}"
    echo ""
    echo -e "${CYAN}Ikuti format JSON berikut:${NC}"
    echo ""
    echo "{"
    echo '  "provider_name": "Nama Provider",'
    echo '  "description": "Deskripsi singkat",'
    echo '  "api_base": "https://api.example.com/",'
    echo '  "model": "model-name",'
    echo '  "api_key": "your-api-key"'
    echo "}"
    echo ""
    echo -e "${YELLOW}Field opsional (tambahkan jika perlu):${NC}"
    echo '"api_version": "v1",'
    echo '"headers": {"Custom-Header": "value"},'
    echo '"docs": "https://docs.example.com"'
    echo ""

    read -p "Masukkan nama provider (tanpa spasi): " provider_raw
    local filename=$(echo "$provider_raw" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    local json_file="$MODEL_DIR/${filename}.json"

    echo ""
    echo -e "${YELLOW}Membuat file: $json_file${NC}"
    echo ""

    # Create basic template
    cat > "$TEMP_FILE" <<EOF
{
  "provider_name": "$provider_raw",
  "description": "Custom AI Provider",
  "api_base": "https://api.example.com/",
  "model": "default-model",
  "api_key": "your-api-key-here"
}
EOF

    # Open editor
    if command -v nano &> /dev/null; then
        nano "$TEMP_FILE"
    elif command -v vim &> /dev/null; then
        vim "$TEMP_FILE"
    else
        echo -e "${RED}Error: Tidak ada editor${NC}"
        rm -f "$TEMP_FILE"
        return
    fi

    # Save
    mv "$TEMP_FILE" "$json_file"

    echo ""
    echo -e "${GREEN}✅ Model manual berhasil dibuat!${NC}"
    read -p "Press Enter to continue..."
}

edit_model() {
    clear_screen
    echo -e "${BOLD}${BLUE}Edit Model${NC}"
    echo ""

    # List models with numbers
    local count=1
    local models=()

    for json_file in "$MODEL_DIR"/*.json; do
        if [[ -f "$json_file" ]]; then
            local filename=$(basename "$json_file" .json)

            # Skip defaults
            case "$filename" in
                "glm"|"groq"|"minimax"|"openai"|"gemini"|"xai"|"ollama")
                    continue
                    ;;
            esac

            models+=("$json_file")

            if command -v jq &> /dev/null; then
                local provider=$(jq -r '.provider_name // "Unknown"' "$json_file" 2>/dev/null)
                echo "$count) $provider ($filename)"
            else
                echo "$count) $filename"
            fi
            ((count++))
        fi
    done

    if [[ ${#models[@]} -eq 0 ]]; then
        echo -e "${RED}Tidak ada model custom untuk diedit${NC}"
        read -p "Press Enter to continue..."
        return
    fi

    echo ""
    read -p "Pilih model [1-$((${#models[@]}))]: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#models[@]} ]]; then
        local selected_file="${models[$((choice-1))]}"

        # Backup original
        cp "$selected_file" "$selected_file.backup"

        # Open editor
        if command -v nano &> /dev/null; then
            nano "$selected_file"
        elif command -v vim &> /dev/null; then
            vim "$selected_file"
        fi

        echo ""
        echo -e "${GREEN}✅ Model updated!${NC}"
        echo -e "${YELLOW}Backup: $selected_file.backup${NC}"
    else
        echo -e "${RED}Pilihan tidak valid!${NC}"
    fi

    read -p "Press Enter to continue..."
}

delete_model() {
    clear_screen
    echo -e "${BOLD}${RED}Hapus Model${NC}"
    echo ""

    # List models
    local count=1
    local models=()

    for json_file in "$MODEL_DIR"/*.json; do
        if [[ -f "$json_file" ]]; then
            local filename=$(basename "$json_file" .json)

            # Skip defaults
            case "$filename" in
                "glm"|"groq"|"minimax"|"openai"|"gemini"|"xai"|"ollama")
                    continue
                    ;;
            esac

            models+=("$json_file")

            if command -v jq &> /dev/null; then
                local provider=$(jq -r '.provider_name // "Unknown"' "$json_file" 2>/dev/null)
                echo "$count) $provider ($filename)"
            else
                echo "$count) $filename"
            fi
            ((count++))
        fi
    done

    if [[ ${#models[@]} -eq 0 ]]; then
        echo -e "${RED}Tidak ada model custom untuk dihapus${NC}"
        read -p "Press Enter to continue..."
        return
    fi

    echo ""
    read -p "Pilih model untuk dihapus [1-$((${#models[@]}))]: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#models[@]} ]]; then
        local selected_file="${models[$((choice-1))]}"
        local filename=$(basename "$selected_file")

        echo ""
        echo -e "${RED}Yakin ingin hapus $filename? [y/N]:${NC}" -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$selected_file"
            echo -e "${GREEN}✅ Model dihapus!${NC}"
        else
            echo -e "${YELLOW}Dibatalkan${NC}"
        fi
    else
        echo -e "${RED}Pilihan tidak valid!${NC}"
    fi

    read -p "Press Enter to continue..."
}

backup_models() {
    clear_screen
    echo -e "${BOLD}${BLUE}Backup Model Config${NC}"
    echo ""

    local backup_dir="$HOME/claude-model-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Copy all custom models
    local count=0
    for json_file in "$MODEL_DIR"/*.json; do
        if [[ -f "$json_file" ]]; then
            local filename=$(basename "$json_file" .json)

            # Skip defaults
            case "$filename" in
                "glm"|"groq"|"minimax"|"openai"|"gemini"|"xai"|"ollama")
                    continue
                    ;;
            esac

            cp "$json_file" "$backup_dir/"
            ((count++))
        fi
    done

    if [[ $count -gt 0 ]]; then
        echo -e "${GREEN}✅ $count model berhasil dibackup!${NC}"
        echo -e "${YELLOW}Folder: $backup_dir${NC}"
        echo ""
        echo "Restore dengan:"
        echo "cp $backup_dir/*.json ~/.local/bin/model/"
    else
        echo -e "${RED}Tidak ada model custom untuk backup${NC}"
        rmdir "$backup_dir" 2>/dev/null
    fi

    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_header
    show_menu
    read -p "Pilihan [0-6]: " choice

    case $choice in
        1) create_from_template ;;
        2) create_manual ;;
        3) edit_model ;;
        4) list_models ;;
        5) delete_model ;;
        6) backup_models ;;
        0)
            clear_screen
            echo -e "${GREEN}Bye! 👋${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid!${NC}"
            sleep 1
            ;;
    esac
done