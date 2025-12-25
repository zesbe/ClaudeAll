#!/usr/bin/env bash

# Add Model Script for Claude-All Dynamic
# Cara mudah nambah model baru ke Claude-All

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
MODEL_DIR="$SCRIPT_DIR/model"

clear
echo -e "${GREEN}===================================${NC}"
echo -e "${GREEN}   Add New Model to Claude-All    ${NC}"
echo -e "${GREEN}===================================${NC}"
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Note: Install jq for better JSON formatting: pkg install jq${NC}"
    echo ""
fi

# Get provider details
echo -e "${BLUE}Enter Provider Details:${NC}"
read -p "Provider Name (e.g., Perplexity AI): " provider_name
read -p "Short Description (e.g., Search-powered AI): " description
read -p "API Base URL (e.g., https://api.perplexity.ai/): " api_base
read -p "Default Model (e.g., llama-3.1-sonar-small-128k-online): " model
read -p "API Key (optional, can set later): " api_key

# Create filename from provider name
filename=$(echo "$provider_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
json_file="$MODEL_DIR/${filename}.json"

# Check if file already exists
if [[ -f "$json_file" ]]; then
    echo ""
    read -p "File already exists. Overwrite? [y/N]: " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Create JSON
echo ""
echo -e "${BLUE}Creating model configuration...${NC}"

# Build JSON
json_content=$(cat <<EOF
{
    "provider_name": "$provider_name",
    "description": "$description",
    "api_base": "$api_base",
    "model": "$model"
EOF
)

# Add API key if provided
if [[ -n "$api_key" ]]; then
    json_content+=",
    \"api_key\": \"$api_key\""
fi

json_content+=$'\n}'

# Write to file
echo "$json_content" > "$json_file"

# Format JSON if jq is available
if command -v jq &> /dev/null; then
    jq . "$json_file" > "$json_file.tmp" && mv "$json_file.tmp" "$json_file"
fi

echo ""
echo -e "${GREEN}✅ Model added successfully!${NC}"
echo ""
echo -e "${YELLOW}File created:${NC} $json_file"
echo ""
echo -e "${YELLOW}To update API key later:${NC}"
echo "claude-all-dynamic → API Key Manager"
echo ""
echo -e "${YELLOW}To use the model:${NC}"
echo "claude-all-dynamic → Select option for $provider_name"

# Show current models
echo ""
echo -e "${BLUE}Current custom models:${NC}"
count=10
for json_file in "$MODEL_DIR"/*.json; do
    if [[ -f "$json_file" ]]; then
        filename=$(basename "$json_file" .json)
        case "$filename" in
            "glm"|"groq"|"minimax"|"openai"|"gemini"|"xai"|"ollama")
                continue
                ;;
        esac

        if command -v jq &> /dev/null; then
            provider=$(jq -r '.provider_name // "Unknown"' "$json_file" 2>/dev/null)
        else
            provider=$filename
        fi
        echo "  $count) $provider"
        ((count++))
    fi
done