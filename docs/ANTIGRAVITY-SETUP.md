# Google AntiGravity Setup Guide

**Google AntiGravity** is Google's internal AI service that provides access to experimental and unreleased AI models. This service is only available to Google employees.

## 🔐 Requirements

- **Google Employee Account** (@google.com)
- **Connected to Google Network** (Corporate network or VPN)
- **Python 3** and **jq** installed

## 🚀 Quick Setup

### Step 1: Run Authentication Script

```bash
python3 scripts/setup_antigravity_auth.py
```

This script will:
1. Open your browser to Google OAuth
2. Wait for you to login and approve
3. Capture the authorization code
4. Exchange it for an access token
5. Save credentials automatically

### Step 2: Use with Claude-All

```bash
claude-all
# Select option 3 (Google AntiGravity)
```

## 📋 Detailed Setup Process

### 1. Prepare Environment

```bash
# Install jq if not installed
# Ubuntu/Debian:
sudo apt-get install jq

# Termux:
pkg install jq

# macOS:
brew install jq
```

### 2. Run Setup Script

```bash
cd Claude-All-New
python3 scripts/setup_antigravity_auth.py
```

The script will display:
- OAuth URL to open
- Instructions for each step
- Progress indicators

### 3. Complete OAuth Flow

1. **Browser Opens**: Google OAuth page
2. **Login**: Use your @google.com account
3. **Approve**: Grant requested permissions
4. **Redirect**: Back to localhost (handled automatically)
5. **Success**: Token saved to `~/.config/claude-all/antigravity/`

### 4. Verify Setup

```bash
# Check if auth file exists
ls -la ~/.config/claude-all/antigravity/

# View saved credentials (formatted)
cat ~/.config/claude-all/antigravity/google_internal_auth.json | jq
```

## 🎯 Available Models

AntiGravity provides access to:

- **Gemini 3 Pro Preview** - Latest experimental model
- **Gemini 2.5 Flash/Pro** - Advanced capabilities
- **Gemini 2.0 Flash Experimental** - Testing features
- **Internal Research Models** - Not publicly available

## 🔧 Configuration

### Auth File Location
```
~/.config/claude-all/antigravity/
└── google_internal_auth.json
```

### Auth File Structure
```json
{
  "type": "authorized_user",
  "client_id": "YOUR_CLIENT_ID",
  "client_secret": "YOUR_CLIENT_SECRET",
  "access_token": "your-access-token",
  "refresh_token": "your-refresh-token",
  "label": "Google Internal AntiGravity",
  "token_uri": "https://oauth2.googleapis.com/token"
}
```

## 🚨 Troubleshooting

### "Authentication not found"
```bash
# Run setup again
python3 scripts/setup_antigravity_auth.py
```

### "Connection failed"
- Verify VPN connection
- Check if on Google network
- Ensure auth file exists

### "Token expired"
The script automatically handles token refresh using the refresh token.

### "Permission denied"
```bash
chmod +x scripts/setup_antigravity_auth.py
```

## 🔄 Using with Claude-All

### Select Models Interactively
```bash
claude-all
# Option 3 → Select from available models
```

### Direct Model Selection
```bash
# Check available models
cat model/antigravity.json | jq '.models[] | {name: .name, id: .id}'

# Use specific model (if supported)
claude-all -m gemini-3-pro-preview
```

## 🔗 API Endpoints

- **AntiGravity API**: `https://antigravity.corp.google.com/v1`
- **Authentication**: Google OAuth 2.0
- **Token Refresh**: `https://oauth2.googleapis.com/token`

## ⚠️ Security Notes

- Keep your auth file secure (600 permissions)
- Don't share credentials
- Auth files contain refresh tokens
- Report suspicious activity immediately

## 📞 Google Internal Support

For Google employees:
- Internal chat: #antigravity-support
- Email: antigravity-team@google.com
- Documentation: Go/antigravity-docs

## 🆚 Alternative: Gemini AI Studio

If you're not a Google employee:
- Use option 2 (Gemini AI Studio) instead
- Get API key from: https://aistudio.google.com/app/apikey
- Still access to powerful Gemini models

---

**Note**: AntiGravity access is exclusive to Google employees connected to the corporate network.