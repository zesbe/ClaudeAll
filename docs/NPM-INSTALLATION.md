# 📦 NPM Installation Guide

## 🚀 Quick Start

### Prerequisites
- **Node.js** >= 14.0.0
- **npm** (usually comes with Node.js)
- **Internet connection** for installation

### Installation Commands

```bash
# Install globally
npm install -g claude-all-ai-launcher

# Verify installation
npm list -g claude-all-ai-launcher

# Check binary accessibility
which claude-all
```

## 🔧 Configuration

### Initial Setup
```bash
# Interactive configuration wizard
npm run config

# Or show current configuration
npm run config show
```

### API Keys Setup
Configure your preferred AI providers during setup:

```bash
# MiniMax (Recommended default)
export MINIMAX_API_KEY="your-api-key-here"

# OpenAI
export OPENAI_API_KEY="your-openai-key"

# Google Gemini
export GOOGLE_GENAI_API_KEY="your-gemini-key"

# Groq
export GROQ_API_KEY="your-groq-key"
```

## 🎯 Available Commands

### Main Commands
```bash
# Launch AI chat
claude-all

# Alternative launchers
ai-chat
claude-launcher

# NPM script runners
npm run claude          # Launch Claude-All
npm run config          # Configure providers
npm run switch          # Switch AI provider
npm run status          # Show current status
npm run help            # Show help menu
```

### Utility Commands
```bash
npm run test            # Test installation
npm run doctor          # System diagnostic
npm run update          # Update package
npm run uninstall       # Remove package
```

## 🔍 Troubleshooting

### Package Not Found
```bash
# Make sure spelling is correct
npm install -g claude-all-ai-launcher

# NOT: claude-all-ai-launche (missing 'r')
```

### Command Not Found
```bash
# Check npm global bin directory
npm config get prefix

# Add to PATH (Linux/macOS)
export PATH="$(npm config get prefix)/bin:$PATH"

# Add to ~/.bashrc or ~/.zshrc for persistence
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Permission Issues
```bash
# Linux/macOS: Use sudo
sudo npm install -g claude-all-ai-launcher

# Or configure npm global directory without sudo
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

### Clean Installation
```bash
# Remove completely
npm uninstall -g claude-all-ai-launcher
npm cache clean --force

# Reinstall fresh
npm install -g claude-all-ai-launcher
```

## 📊 Package Information

- **Name**: `claude-all-ai-launcher`
- **Version**: 8.1.1
- **License**: MIT
- **Node.js Required**: >=14.0.0
- **Platform**: Cross-platform (Linux, macOS, Windows, Termux, FreeBSD, SunOS)

## 🌐 Provider Support

### Supported AI Providers
- **MiniMax** - Chinese AI models
- **Google Gemini** - Multimodal AI
- **OpenAI** - GPT-4, GPT-3.5 Turbo
- **Groq** - Ultra-fast inference
- **Ollama** - Local LLM hosting
- **xAI/Grok** - xAI models
- **ZhipuAI/GLM** - GLM series
- **Custom APIs** - Any REST endpoint

### Switching Providers
```bash
# Interactive provider switch
npm run switch

# Direct provider specification
claude-all --provider minimax
claude-all --provider gemini
claude-all --provider openai
```

## 🔗 Links

- **[NPM Package Page](https://www.npmjs.com/package/claude-all-ai-launcher)**
- **[GitHub Repository](https://github.com/zesbe/ClaudeAll)**
- **[Related: TMUX & Byobu Enhanced](https://www.npmjs.com/package/tmux-byobu-enhanced)**

## 🆘 Support

If you encounter issues:

1. Check the [troubleshooting section](../README.md#-troubleshooting)
2. Run `npm run doctor` for system diagnostic
3. [Report an issue](https://github.com/zesbe/ClaudeAll/issues)
4. [Join the discussion](https://github.com/zesbe/ClaudeAll/discussions)