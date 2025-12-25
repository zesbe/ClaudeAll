#!/bin/bash
# xAI Chat Wrapper for Claude-All
# Uses OpenAI-compatible API

XAI_API_KEY="$1"
MODEL="${2:-grok-4-latest}"
shift 2

# Build messages array
messages="["
add_message=true

while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--system" && -n "$2" ]]; then
        if [[ "$messages" != "[" ]]; then
            messages+=","
        fi
        messages+="{\"role\":\"system\",\"content\":\"$2\"}"
        add_message=true
        shift 2
    elif [[ "$1" == "--user" && -n "$2" ]]; then
        if [[ "$messages" != "[" ]]; then
            messages+=","
        fi
        messages+="{\"role\":\"user\",\"content\":\"$2\"}"
        add_message=true
        shift 2
    elif [[ "$1" == "--assistant" && -n "$2" ]]; then
        if [[ "$messages" != "[" ]]; then
            messages+=","
        fi
        messages+="{\"role\":\"assistant\",\"content\":\"$2\"}"
        add_message=true
        shift 2
    else
        # Default as user message
        if [[ "$messages" != "[" ]]; then
            messages+=","
        fi
        messages+="{\"role\":\"user\",\"content\":\"$1\"}"
        shift
    fi
done

messages+="]"

# API call
curl -s "https://api.x.ai/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $XAI_API_KEY" \
    -d "{
        \"messages\": $messages,
        \"model\": \"$MODEL\",
        \"stream\": false,
        \"temperature\": 0
    }" | jq -r '.choices[0].message.content'