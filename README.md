# 🤖 Claude-All: Universal AI CLI Launcher v8.1.4

[![NPM Version](https://img.shields.io/npm/v/claude-all-ai-launcher.svg)](https://www.npmjs.com/package/claude-all-ai-launcher)
[![NPM Downloads](https://img.shields.io/npm/dt/claude-all-ai-launcher.svg)](https://www.npmjs.com/package/claude-all-ai-launcher)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Termux-green.svg)](https://github.com/zesbe/ClaudeAll)
[![Node.js](https://img.shields.io/badge/Node.js-%3E%3D14.0.0-brightgreen.svg)](https://nodejs.org/)

**🚀 Universal AI CLI Launcher - Use Claude Code with ANY AI Provider via NPM!**

🔥 **Related Projects:**
- **[TMUX & Byobu Enhanced](https://github.com/zesbe/tmux-byobu-scripts)** - 🖱️ `npm install -g tmux-byobu-enhanced`
- **[Claude-All NPM Package](https://www.npmjs.com/package/claude-all-ai-launcher)** - 🤖 `npm install -g claude-all-ai-launcher`

```
┌─────────────────────────────────────────────────────┐
│ MiniMax • Gemini AI Studio • OpenAI • Groq        │
│ xAI/Grok • ZhipuAI/GLM • Ollama • Custom APIs    │
└─────────────────────────────────────────────────────┘
```

## ⚡ Quick Install (NPM - Global)

```bash
# Install Claude-All AI Launcher
npm install -g claude-all-ai-launcher

# Configure API keys
npm run config

# Start AI chat
claude-all
```

### 🎯 One-Command Installation

```bash
# Install and configure in one line
npm install -g claude-all-ai-launcher && npm run config && claude-all
```

## 🌟 Key Features

### 🤖 Universal AI Support (23 Providers)
- **MiniMax** - High-performance Chinese AI
- **Google Gemini** - Advanced multimodal AI
- **OpenAI** - GPT-4 and GPT-3.5 Turbo
- **xAI/Grok** - Real-time AI by xAI
- **Groq** - Ultra-fast Llama inference
- **DeepSeek** - Advanced reasoning AI
- **Perplexity** - Search-powered AI
- **Letta AI** - Stateful AI agents
- **Ollama** - Local LLM hosting
- **ZhipuAI/GLM** - GLM series models
- **Cohere** - Enterprise AI models
- **Mistral** - European AI models
- **Moonshot** - Chinese AI platform
- **Qwen** - Alibaba Cloud AI
- **OpenRouter** - Multi-provider aggregator
- **Custom APIs** - Any REST API endpoint

## 📡 API Endpoints & Configuration

### Quick Access Models

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 1 | **MiniMax** | `https://api.minimax.io/anthropic` | [Get Key](https://platform.minimax.io/) | `MINIMAX_API_KEY` |
| 2 | **Gemini (API Key)** | `https://generativelanguage.googleapis.com/v1beta/anthropic` | [Get Key](https://aistudio.google.com/app/apikey) | `GEMINI_API_KEY` |
| 3 | **AntiGravity (OAuth)** | `https://antigravity.corp.google.com/v1` | Internal Google Only | `GOOGLE_AUTH_TOKEN` |
| 4 | **OpenAI** | `https://api.openai.com/v1` | [Get Key](https://platform.openai.com/api-keys) | `OPENAI_API_KEY` |
| 5 | **OpenAI (OAuth)** | `https://api.openai.com/v1` | OAuth Flow | `OPENAI_ACCESS_TOKEN` |

### Cloud Providers

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 6 | **xAI / Grok** | `https://api.x.ai/v1` | [Get Key](https://console.x.ai/) | `XAI_API_KEY` |
| 7 | **ZhipuAI / GLM** | `https://open.bigmodel.cn/api/paas/v4` | [Get Key](https://open.bigmodel.cn/) | `ZHIPUAI_API_KEY` |
| 8 | **Groq** | `https://api.groq.com/openai/v1` | [Get Key](https://console.groq.com/keys) | `GROQ_API_KEY` |
| 9 | **Perplexity** | `https://api.perplexity.ai/` | [Get Key](https://www.perplexity.ai/settings/api) | `PERPLEXITY_API_KEY` |
| 10 | **Cohere** | `https://api.cohere.ai/v1` | [Get Key](https://dashboard.cohere.com/api-keys) | `COHERE_API_KEY` |
| 11 | **DeepSeek** | `https://api.deepseek.com/v1` | [Get Key](https://platform.deepseek.com/api_keys) | `DEEPSEEK_API_KEY` |

### AI Agents & Special

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 17 | **Letta AI** | `https://api.letta.com/v1` | [Documentation](https://docs.letta.com) | `LETTA_API_KEY` |

### Local & Self-Hosted

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 12 | **Ollama** | `http://localhost:11434/v1` | Local (No Key Required) | - |

### Regional Providers

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 13 | **Mistral** | `https://api.mistral.ai/v1` | [Get Key](https://console.mistral.ai/api-keys/) | `MISTRAL_API_KEY` |
| 14 | **Moonshot** | `https://api.moonshot.cn/v1` | [Get Key](https://platform.moonshot.cn/console/api-keys) | `MOONSHOT_API_KEY` |
| 15 | **Qwen** | `https://dashscope.aliyuncs.com/compatible-mode/v1` | [Get Key](https://dashscope.console.aliyun.com/apiKey) | `QWEN_API_KEY` |

### Multi-Provider

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 16 | **OpenRouter** | `https://openrouter.ai/api/v1` | [Get Key](https://openrouter.ai/keys) | `OPENROUTER_API_KEY` |

### Tools & Utilities

| # | Tool | Description |
|---|------|-------------|
| 18 | **API Key Manager** | Manage and update all API keys |
| 19 | **Claude Master Tool** | Advanced UI for model management |
| 20 | **API Manager** | Monitor API usage and costs |
| 21 | **Model Management** | Add/Edit/Delete custom models |
| 22 | **Custom Models** | Your custom model configurations |
| 23 | **Model Management Tools** | Advanced model configuration |

### Environment Variables Setup

```bash
# Quick Access Models
export MINIMAX_API_KEY="your-minimax-key"
export GEMINI_API_KEY="your-gemini-key"
export OPENAI_API_KEY="your-openai-key"

# Cloud Providers
export XAI_API_KEY="your-xai-key"
export ZHIPUAI_API_KEY="your-glm-key"
export GROQ_API_KEY="your-groq-key"
export PERPLEXITY_API_KEY="your-perplexity-key"
export COHERE_API_KEY="your-cohere-key"
export DEEPSEEK_API_KEY="your-deepseek-key"

# Regional Providers
export MISTRAL_API_KEY="your-mistral-key"
export MOONSHOT_API_KEY="your-moonshot-key"
export QWEN_API_KEY="your-qwen-key"

# Multi-Provider
export OPENROUTER_API_KEY="your-openrouter-key"

# AI Agents
export LETTA_API_KEY="your-letta-key"
```

### API Key Storage Locations

Claude-All automatically saves your API keys securely:

```bash
~/.minimax_api_key      # MiniMax
~/.gemini_api_key       # Gemini
~/.openai_api_key       # OpenAI
~/.xai_api_key          # xAI/Grok
~/.zhipuai_api_key      # GLM
~/.groq_api_key         # Groq
~/.perplexity_api_key   # Perplexity
~/.cohere_api_key       # Cohere
~/.deepseek_api_key     # DeepSeek
~/.mistral_api_key      # Mistral
~/.moonshot_api_key     # Moonshot
~/.qwen_api_key         # Qwen
~/.openrouter_api_key   # OpenRouter
~/.letta_api_key        # Letta AI
```

### 🌐 Cross-Platform Compatibility
- ✅ **Linux** (Ubuntu, Debian, CentOS, Arch)
- ✅ **macOS** (Intel & Apple Silicon)
- ✅ **Windows** (WSL2 & PowerShell)
- ✅ **Termux** (Android)
- ✅ **FreeBSD/OpenBSD**
- ✅ **SunOS/Solaris**

### 🎯 Easy Installation & Usage
```bash
# Install globally (one command)
npm install -g claude-all-ai-launcher

# Configure API keys
npm run config

# Start AI chat
claude-all

# Alternative commands
ai-chat
claude-launcher

# Or use NPM commands
npm run claude
npm run config
npm run switch
```

### 📦 Available NPM Commands
```bash
# Main AI launcher
npm run claude          # Launch Claude-All
npm run config          # Configure providers
npm run switch          # Switch AI provider
npm run status          # Show current status
npm run help            # Show help menu

# Development & testing
npm run test            # Test installation
npm run doctor          # System diagnostic
npm run update          # Update package
```

### 🔍 Installation Verification
```bash
# Check if package is installed globally
npm list -g claude-all-ai-launcher

# Verify binary is accessible
which claude-all
which ai-chat

# Test basic functionality
claude-all --version
npm run doctor
```

### 🖱️ Enhanced Terminal Tools Bundle
- **[TMUX & Byobu Enhanced](https://github.com/zesbe/tmux-byobu-scripts)** - 🎯 **Recommended for Claude-All users**
  ```bash
  npm install -g tmux-byobu-enhanced
  npm run config
  ```
  - ✅ Smooth mouse wheel scrolling
  - ✅ Click-to-select panes
  - ✅ Drag border resizing
  - ✅ F-key shortcuts for Byobu
  - ✅ Enhanced status bars
  - ✅ Cross-platform compatibility

### 💡 Perfect Combination
Claude-All + TMUX/Byobu Enhanced = Ultimate Productivity:
```bash
# Install both tools
npm install -g claude-all-ai-launcher tmux-byobu-enhanced

# Configure both
npm run config  # Claude-All
npm run config  # TMUX/Byobu

# Start enhanced terminal session
tmux
claude-all
```

## 🚀 Installation Methods

### 🎯 Method 1: Complete Setup (Recommended)
```bash
# Install Claude-All AI Launcher
npm install -g claude-all-ai-launcher

# Install Enhanced Terminal Tools
npm install -g tmux-byobu-enhanced

# Configure both tools
npm run config  # Claude-All
npm run config  # TMUX/Byobu
```

### 🔧 Method 2: AI Launcher Only
```bash
npm install -g claude-all-ai-launcher
npm run config
```

### 🖱️ Method 3: Terminal Tools Only
```bash
npm install -g tmux-byobu-enhanced
npm run config
```

### 📂 Method 4: GitHub Repository
```bash
git clone https://github.com/zesbe/ClaudeAll.git
cd ClaudeAll
npm install -g .
npm run config

# Optional: Install TMUX & Byobu
npm install -g tmux-byobu-enhanced
```

### 📦 Method 5: Direct Download
```bash
# Claude-All
wget https://github.com/zesbe/ClaudeAll/archive/main.zip
unzip main.zip
cd ClaudeAll-main
npm install -g .

# TMUX & Byobu
wget https://github.com/zesbe/tmux-byobu-scripts/archive/main.zip
unzip main.zip
cd tmux-byobu-scripts-main
npm install -g .
```

## 📱 Usage

### Basic Commands
```bash
# Start AI launcher
claude-all

# Alternative commands
ai-chat
claude-launcher

# NPM commands
npm run claude
npm run launch
```

### Provider Management
```bash
# Switch AI provider
claude-all --provider minimax
claude-all --provider gemini
claude-all --provider openai

# List available providers
claude-all --list-providers

# Interactive provider switch
npm run switch
```

### Configuration
```bash
# Interactive configuration wizard
npm run config

# Show current configuration
npm run config show

# Advanced configuration
claude-all --config
```

## ⚙️ Configuration

### API Keys Setup
```bash
# Interactive setup
npm run config

# Environment variables
export MINIMAX_API_KEY="your-api-key"
export OPENAI_API_KEY="your-openai-key"
export GROQ_API_KEY="your-groq-key"
export GOOGLE_GENAI_API_KEY="your-gemini-key"
```

### Configuration File
```json
{
  "version": "8.1.0",
  "default_provider": "minimax",
  "providers": {
    "minimax": {
      "name": "MiniMax",
      "enabled": true,
      "endpoint": "https://api.minimax.chat/v1",
      "models": ["abab6.5", "abab6.5s", "abab5.5"],
      "api_key": ""
    }
  }
}
```

## 🔧 Advanced Features

### Custom Provider Support
```bash
# Add custom provider
claude-all --add-provider myprovider
claude-all --endpoint https://api.example.com/v1
claude-all --model my-custom-model
```

### Session Management
```bash
# Save conversation
claude-all --save-session my-chat

# Load session
claude-all --load-session my-chat

# List sessions
claude-all --list-sessions
```

### File Operations
```bash
# Process file
claude-all --file document.txt

# Code analysis
claude-all --analyze script.py

# Batch processing
claude-all --batch *.md
```

## 🏗️ Developer Mode

### CLI Options
```bash
# Verbose output
claude-all --verbose

# Debug mode
claude-all --debug

# JSON output
claude-all --json

# Stream mode
claude-all --stream
```

### Plugin System
```bash
# List plugins
claude-all --list-plugins

# Enable plugin
claude-all --enable-plugin plugin-name

# Custom plugin directory
claude-all --plugin-dir ~/.claude-all/plugins
```

## 🔍 Troubleshooting

### Common NPM Issues
```bash
# Check if package is installed
npm list -g claude-all-ai-launcher

# Package not found? Make sure spelling is correct:
npm install -g claude-all-ai-launcher  # NOT claude-all-ai-launche

# Permission issues? Use sudo (Linux/macOS):
sudo npm install -g claude-all-ai-launcher

# Clean npm cache
npm cache clean --force

# Reinstall completely
npm uninstall -g claude-all-ai-launcher
npm install -g claude-all-ai-launcher
```

### Binary/Command Issues
```bash
# Check if binary is accessible
which claude-all
which ai-chat

# If command not found, check npm global bin directory:
npm config get prefix
# Add the output to your PATH:

# Linux/macOS: Add to ~/.bashrc or ~/.zshrc
export PATH="$(npm config get prefix)/bin:$PATH"

# Windows: Add to Environment Variables
# npm config get prefix ; add this to PATH
```

### Health Check
```bash
# System diagnostic
npm run doctor

# Test installation
npm run test

# Check configuration
npm run config show

# Test API connections
claude-all --test-connections

# Verify API keys
claude-all --verify-keys
```

### Logs & Debugging
```bash
# View logs
claude-all --logs

# Enable debug logging
claude-all --debug --verbose

# Check npm logs
npm ls -g --depth=0

# Verbose npm installation
npm install -g claude-all-ai-launcher --verbose
```

## 📚 Documentation

- **[NPM Package](https://www.npmjs.com/package/claude-all-ai-launcher)** - Package page and documentation
- **[📦 NPM Installation Guide](docs/NPM-INSTALLATION.md)** - Complete installation & setup guide
- **[Full Documentation](docs/)** - Comprehensive guides
- **[Provider Setup](docs/providers.md)** - AI provider configuration
- **[API Reference](docs/api.md)** - Command reference
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues

## 🆘 Support

- **[NPM Issues](https://www.npmjs.com/package/claude-all-ai-launcher)** - Report package issues
- **[GitHub Issues](https://github.com/zesbe/ClaudeAll/issues)** - Bug reports and feature requests
- **[GitHub Discussions](https://github.com/zesbe/ClaudeAll/discussions)** - Community help
- **[GitHub Wiki](https://github.com/zesbe/ClaudeAll/wiki)** - Additional guides

## 📊 Package Information

- **Package Name**: `claude-all-ai-launcher`
- **Version**: 8.1.4
- **License**: MIT
- **Node.js Required**: >=14.0.0
- **Total Files**: 163+
- **Package Size**: ~243KB
- **Unpacked Size**: ~854KB

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 🎯 Quick Start Examples

### Chat with MiniMax
```bash
claude-all --provider minimax "Hello, explain quantum computing"
```

### Code Analysis with OpenAI
```bash
claude-all --provider openai --file mycode.py "Explain this code"
```

### Local LLM with Ollama
```bash
claude-all --provider ollama --model llama3 "What is artificial intelligence?"
```

### Batch Processing
```bash
claude-all --batch *.md --provider groq "Summarize each file"
```

---

## 🚀 Why Claude-All?

- **🌍 Universal:** Works with any AI provider
- **⚡ Fast:** Optimized for speed and efficiency
- **🛡️ Reliable:** Built-in error handling and retries
- **🎯 Simple:** Easy installation and configuration
- **🔧 Powerful:** Advanced features for power users
- **📱 Cross-Platform:** Works everywhere Node.js runs
- **🖱️ Enhanced Terminal:** Perfect integration with TMUX & Byobu for superior productivity
- **🚀 Complete Solution:** AI chat + enhanced terminal = ultimate development environment

**🤖 Experience the future of AI interaction with Claude-All + Enhanced Terminal Tools!**

---

*Made with ❤️ by [zesbe](https://github.com/zesbe)*