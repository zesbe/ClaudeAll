#!/bin/bash

# Wrapper for claude CLI with GLM model support
# This enables /model command to work with GLM

GLM_API_KEY_FILE="$HOME/.glm_api_key"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Function to load API key with error handling
load_api_key() {
    local key_file="$1"
    local provider_name="$2"

    if [ ! -f "$key_file" ]; then
        echo -e "${RED}Error: No $provider_name API key found${NC}" >&2
        echo "Please run 'claude-all 7' first to set up your API key." >&2
        return 1
    fi

    local api_key
    api_key=$(cat "$key_file" 2>/dev/null)
    if [ -z "$api_key" ]; then
        echo -e "${RED}Error: $provider_name API key file is empty${NC}" >&2
        echo "Please run 'claude-all 7' again to set up your API key." >&2
        return 1
    fi

    echo "$api_key"
    return 0
}

# Get API key with proper error handling
API_KEY=$(load_api_key "$GLM_API_KEY_FILE" "GLM")
if [ $? -ne 0 ]; then
    exit 1
fi

# Set environment variables
export ANTHROPIC_AUTH_TOKEN="$API_KEY"
export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
export ANTHROPIC_API_KEY="$API_KEY"

# Model name from argument or default
MODEL_NAME="${1:-glm-4.6}"

echo -e "${BLUE}Starting GLM Chat${NC}"
echo -e "${GREEN}Model: $MODEL_NAME${NC}"
echo ""

# Start claude with model
exec claude --model "$MODEL_NAME" "${@:2}"
