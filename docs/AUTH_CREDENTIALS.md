# AntiGravity Authentication Credentials

For Google employees wanting to use AntiGravity (option 3), you have two options:

## Option 1: Use CLIProxyAPI (Recommended)

If you have CLIProxyAPI installed, you can extract credentials from it:

```bash
# Get credentials from CLIProxyAPI config
cliproxy config show
```

Or get the CLIProxyAPI client ID and secret from:
- Your CLIProxyAPI installation directory
- Google internal documentation
- Ask the AntiGravity team

## Option 2: Get Your Own Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or use existing one
3. Go to "APIs & Services" > "Credentials"
4. Create "OAuth 2.0 Client ID"
5. Select "Web application"
6. Add authorized redirect URI: `http://localhost:8080/callback`
7. Copy your Client ID and Client Secret

## Security Notes

These credentials are for Google internal use only:
- They allow access to Google's internal OAuth flow
- Used specifically for AntiGravity API authentication
- Safe to share among Google employees
- Should not be committed to public repositories (due to automated detection)

## Quick Setup for Google Employees

```bash
# 1. Install dependencies
pkg install jq python3

# 2. Run setup script with your credentials
python3 scripts/setup_antigravity_auth.py

# 3. Use with claude-all
claude-all  # Select option 3
```

## Need Help?

For Google employees:
- Internal chat: #antigravity-support
- Email: antigravity-team@google.com