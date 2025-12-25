#!/usr/bin/env bash

# Custom Claude Configuration Script
# Add custom permissions and features to Claude

echo "🔧 Configuring Custom Claude Features..."

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Backup original settings
cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d)"

# Add custom permissions for enhanced functionality
cat << 'EOF' > /tmp/custom_permissions.json
{
  "permissions": {
    "allow": [
      "Bash(*/node_modules/.bin/*)",
      "Bash(*/dist/*)",
      "Bash(python3 -m venv*)",
      "Bash(docker compose*)",
      "Bash(kubectl*)",
      "Bash(helm*)",
      "Bash(terraform*)",
      "Bash(aws*)",
      "Bash(gcloud*)",
      "Bash(az*)",
      "WebFetch(domain:*api.*)",
      "WebFetch(domain:*docs.*)",
      "WebFetch(domain:*raw.githubusercontent.com)",
      "Bash(jest*)",
      "Bash(python3 -m pytest*)",
      "Bash(python3 -m pip install*)",
      "Bash(yarn*)",
      "Bash(pnpm*)",
      "Bash(npx --yes*)",
      "Bash(cargo*)",
      "Bash(rustc*)"
    ]
  },
  "env": {
    "CLAUDE_CONTEXT_SIZE": "200000",
    "CLAUDE_TEMPERATURE": "0.7",
    "CLAUDE_MAX_TOKENS": "8192",
    "CLAUDE_ENABLE_TOOLS": "true"
  },
  "features": {
    "enhanced_file_history": true,
    "project_context": true,
    "auto_save_session": true,
    "debug_mode": false,
    "custom_templates": true
  }
}
EOF

# Merge with existing settings
node -e "
const fs = require('fs');
const settings = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8'));
const custom = JSON.parse(fs.readFileSync('/tmp/custom_permissions.json', 'utf8'));

// Merge permissions
settings.permissions.allow = [...new Set([...settings.permissions.allow, ...custom.permissions.allow])];

// Add or update env
settings.env = {...settings.env, ...custom.env};

// Add features
settings.features = {...settings.features, ...custom.features};

fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(settings, null, 2));
console.log('Settings updated successfully!');
"

# Clean up
rm -f /tmp/custom_permissions.json

echo "✅ Custom Claude configuration updated!"
echo ""
echo "📋 Added Features:"
echo "  • Extended CLI tool permissions (npm, yarn, pnpm, cargo, etc.)"
echo "  • Cloud provider CLI support (aws, gcloud, az)"
echo "  • Enhanced API fetching capabilities"
echo "  • Testing framework support (jest, pytest)"
echo "  • Docker/Kubernetes support"
echo "  • Custom environment variables"
echo "  • Feature flags for enhanced functionality"