# Custom Claude Hooks Guide

## Available Hook Events

### 1. SessionStart Hook
Already implemented for Superpowers. Location: `~/.claude/hooks/session-start.sh`

### 2. PreToolUse Hook
Triggered before any tool is used.

**Example: `~/.claude/hooks/pre-tool-use.sh`**
```bash
#!/bin/bash
# Log all tool usage
echo "$(date): Using tool $1 with args: $2" >> ~/.claude/tool-usage.log
```

### 3. PostToolUse Hook
Triggered after tool execution.

**Example: `~/.claude/hooks/post-tool-use.sh`**
```bash
#!/bin/bash
# Auto-commit changes after file operations
if [[ "$1" == "Write" || "$1" == "Edit" ]]; then
    git add -A 2>/dev/null || true
fi
```

### 4. SessionEnd Hook
Triggered when Claude session ends.

**Example: `~/.claude/hooks/session-end.sh`**
```bash
#!/bin/bash
# Clean up temporary files
rm -rf /tmp/claude-* 2>/dev/null || true
# Save session summary
echo "Session ended at $(date)" >> ~/.claude/session-history.log
```

### 5. UserPromptSubmit Hook
Triggered before processing user input.

**Example: `~/.claude/hooks/user-prompt-submit.sh`**
```bash
#!/bin/bash
# Auto-correct common typos
echo "$1" | sed 's/claude-all/claude/g'
```

### 6. Stop Hook
Triggered on graceful shutdown.

**Example: `~/.claude/hooks/stop.sh`**
```bash
#!/bin/bash
# Backup important files
cp ~/.claude/history.jsonl ~/.claude/backups/history-$(date +%Y%m%d).jsonl
```

## Installing Custom Hooks

1. Create hook script in `~/.claude/hooks/`
2. Make it executable: `chmod +x hook-name.sh`
3. Update hooks.json:

```json
{
  "hooks": {
    "SessionStart": "session-start.sh",
    "PreToolUse": "pre-tool-use.sh",
    "PostToolUse": "post-tool-use.sh",
    "SessionEnd": "session-end.sh",
    "UserPromptSubmit": "user-prompt-submit.sh",
    "Stop": "stop.sh"
  }
}
```

## Hook Return Format

Hooks should return JSON output:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "EventName",
    "additionalContext": "Additional context for Claude",
    "modifications": {
      "settings": {...},
      "environment": {...}
    }
  }
}
```

## Advanced Hook Ideas

### Auto-Save Hook
```bash
# Auto-save work every 10 minutes
#!/bin/bash
if [[ $(($(date +%s) % 600)) -lt 5 ]]; then
    echo "Auto-saving session..."
    # Add save logic here
fi
```

### Context Enhancement Hook
```bash
# Add project context
if [[ -f "project.md" ]]; then
    echo -e "\n<project-context>\n$(cat project.md)\n</project-context>"
fi
```

### Performance Monitoring Hook
```bash
# Log performance metrics
echo "$(date),$1,$(($(date +%s%N)/1000000))" >> ~/.claude/performance.log
```

## Security Notes

- Hooks run with your user permissions
- Validate all hook inputs
- Avoid executing arbitrary commands from hook input
- Keep hooks simple and focused