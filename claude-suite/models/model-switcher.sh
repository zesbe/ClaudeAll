#!/bin/bash

# Model switcher for chat mode
# Usage: pipe stdin to this script

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
MODEL_FILE="$SCRIPT_DIR/model/glm.json"

# Read stdin line by line
while IFS= read -r line; do
    # Check if line starts with /model
    if [[ "$line" =~ ^/model ]]; then
        # Extract model name if provided
        if [[ "$line" =~ ^/model[[:space:]]+([a-zA-Z0-9._-]+) ]]; then
            new_model="${BASH_REMATCH[1]}"
            # Prepend zhipu/ if not present
            if [[ ! "$new_model" == zhipu/* ]]; then
                new_model="zhipu/$new_model"
            fi
            echo -e "${YELLOW}Switching to model: $new_model${NC}" >&2
            # Output the model switch command
            echo "/model_switch:$new_model"
        else
            # Show model selection menu
            echo "" >&2
            echo "=== Select Model ===" >&2
            python3 -c "
import json

try:
    with open('$MODEL_FILE', 'r') as f:
        data = json.load(f)
        for i, model in enumerate(data['models'], 1):
            print(f'{i}) {model[\"name\"]} - {model[\"description\"]}')
    print('')
except Exception as e:
    print(f'Error: {e}')
" >&2

            echo -n "Select model [1-9]: " >&2
            read -t 5 choice 2>/dev/null

            if [ -n "$choice" ] && [[ "$choice" =~ ^[0-9]+$ ]]; then
                model_id=$(python3 -c "
import json
with open('$MODEL_FILE', 'r') as f:
    data = json.load(f)
    try:
        idx = int('$choice') - 1
        if 0 <= idx < len(data['models']):
            print(data['models'][idx]['id'])
    except:
        pass
")
                if [ -n "$model_id" ]; then
                    echo -e "${GREEN}✓ Selected: $model_id${NC}" >&2
                    echo "/model_switch:$model_id"
                else
                    echo -e "${RED}Invalid selection${NC}" >&2
                fi
            else
                echo -e "${YELLOW}No selection, keeping current model${NC}" >&2
            fi
        fi
    else
        # Regular line, output as is
        echo "$line"
    fi
done
