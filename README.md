# 🤖 Claude-All: Universal AI CLI Launcher v8.4.1

[![NPM Version](https://img.shields.io/npm/v/claude-all-ai-launcher.svg)](https://www.npmjs.com/package/claude-all-ai-launcher)
[![NPM Downloads](https://img.shields.io/npm/dt/claude-all-ai-launcher.svg)](https://www.npmjs.com/package/claude-all-ai-launcher)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Termux-green.svg)](https://github.com/zesbe/ClaudeAll)
[![Node.js](https://img.shields.io/badge/Node.js-%3E%3D14.0.0-brightgreen.svg)](https://nodejs.org/)

**🚀 Universal AI CLI Launcher - One Tool, 60+ AI Models, Zero Hassle!**

```
┌──────────────────────────────────────────────────────────────┐
│ Universal OAuth • MiniMax • Gemini • OpenAI • Mistral      │
│ xAI/Grok • GLM • Letta Memory • Groq • DeepSeek • Custom   │
│                                                              │
│ 🔥 NEW v8.4.1: Auto-Install CCS for 37+ OAuth Models!      │
└──────────────────────────────────────────────────────────────┘
```

---

## 🎯 Quick Start

### Install
```bash
# Option 1: NPM (Recommended)
npm install -g claude-all-ai-launcher

# Option 2: Git Clone
git clone https://github.com/zesbe/ClaudeAll.git
cd ClaudeAll
ln -s $(pwd)/claude-all /usr/local/bin/claude-all
```

### Run
```bash
claude-all
# Choose from 20+ providers and 60+ models!
```

---

## 🌟 Key Features

### ✨ What's New in v8.4.1

🚀 **Universal OAuth Auto-Setup** (Option 3)
- **Auto-Installer**: CCS installed automatically if missing (~10MB, 30 seconds)
- **37+ OAuth Models**: GPT-5.2, Claude Opus 4.5, Gemini 3, etc
- **5 Providers**: Gemini (8), Codex (18), GitHub Copilot (4), AntiGravity (6), Kiro AWS
- **Zero Manual Setup**: One command, everything automatic!

🇫🇷 **Mistral 15 Models** (Option 13)
- Latest 2025 models: mistral-large-latest, devstral-2, codestral-latest
- Specialist models: magistral, ministral, ocr-3, voxtral-mini

🧠 **Letta Memory Agent** (Option 17)
- Fixed AUTH_TOKEN authentication
- Auto-load API key from `~/.letta_api_key`
- 5 backend options: Claude Opus/Sonnet/Haiku, GPT-4o, Gemini 2.0

### 🎯 Core Features

✅ **23+ AI Providers** - MiniMax, Gemini, OpenAI, Mistral, xAI, GLM, Groq, DeepSeek, Letta, etc
✅ **60+ Models** - Including OAuth models (GPT-5, Claude Opus 4.5, Gemini 3)
✅ **Auto-Installer** - CCS OAuth setup in 30 seconds
✅ **API Key Management** - Secure storage in `~/.{provider}_api_key`
✅ **Custom Models** - JSON configs in `model/` directory
✅ **Cross-Platform** - Linux, macOS, Windows, Termux, FreeBSD

---

## 📡 Complete API Endpoints & Configuration

### 🔥 Universal OAuth (Option 3) - Auto-Setup

**CCS will be installed automatically if not present!**

| Provider | Models | API Endpoint | Authentication |
|----------|--------|--------------|----------------|
| **Gemini (Google)** | 8 models | Via CCS Proxy | `ccs gemini --auth` |
| **Codex (OpenAI)** | 18 models | Via CCS Proxy | `ccs codex --auth` |
| **GitHub Copilot** | 4 models | Via CCS Proxy | `ccs copilot --auth` |
| **AntiGravity (Anthropic)** | 6 models | Via CCS Proxy | `ccs agy --auth` |
| **Kiro (AWS)** | AWS Claude | Via CCS Proxy | `ccs kiro --auth` |

**Available Models (37+ total):**
- **Gemini**: gemini-2.5-pro, gemini-3-pro-preview, gemini-3-flash-preview, etc
- **Codex**: gpt-5.2, gpt-5.2-pro, gpt-5.1-codex-max, o1-preview, o1-pro, etc
- **GitHub Copilot**: claude-opus-4.5, claude-sonnet-4.5, gpt-5.1, gpt-4o
- **AntiGravity**: gemini-claude-opus-4-5-thinking, claude-opus-4.2, etc
- **Kiro AWS**: AWS-hosted Claude models

📖 **[Complete OAuth Guide](OAUTH-AUTO-SETUP.md)**

---

### 🚀 Quick Access Models

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 1 | **MiniMax** | `https://api.minimax.io/anthropic` | [Get Key](https://platform.minimax.io/) | `MINIMAX_API_KEY` |
| 2 | **Gemini (API Key)** | `https://generativelanguage.googleapis.com/v1beta/anthropic` | [Get Key](https://aistudio.google.com/app/apikey) | `GEMINI_API_KEY` |
| 3 | **Universal OAuth** | Via CCS Proxy (Auto-Install) | OAuth Flow | Multiple providers |
| 4 | **OpenAI** | `https://api.openai.com/v1` | [Get Key](https://platform.openai.com/api-keys) | `OPENAI_API_KEY` |
| 5 | **OpenAI OAuth** | `https://api.openai.com/v1` | OAuth Flow (Experimental) | `OPENAI_ACCESS_TOKEN` |

**MiniMax Models:**
- **minimax-m2.1** 🆕 - Latest coding model (10B params, optimized for Rust, Java, Go, C++, TypeScript)
- claude-3-5-sonnet-20241022 - Claude-compatible endpoint
- abab6.5, abab6.5s, abab5.5

---

### ☁️ Cloud Providers

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 6 | **xAI / Grok** | `https://api.x.ai/v1` | [Get Key](https://console.x.ai/) | `XAI_API_KEY` |
| 7 | **ZhipuAI / GLM** | `https://open.bigmodel.cn/api/paas/v4` | [Get Key](https://open.bigmodel.cn/) | `GLM_API_KEY` |
| 8 | **Groq** | `https://api.groq.com/openai/v1` | [Get Key](https://console.groq.com/keys) | `GROQ_API_KEY` |
| 9 | **Perplexity** | `https://api.perplexity.ai/` | [Get Key](https://www.perplexity.ai/settings/api) | `PERPLEXITY_API_KEY` |
| 10 | **Cohere** | `https://api.cohere.ai/v1` | [Get Key](https://dashboard.cohere.com/api-keys) | `COHERE_API_KEY` |
| 11 | **DeepSeek** | `https://api.deepseek.com/v1` | [Get Key](https://platform.deepseek.com/api_keys) | `DEEPSEEK_API_KEY` |

---

### 🏠 Local & Self-Hosted

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 12 | **Ollama** | `http://localhost:11434/v1` | Local (No Key) | - |

---

### 🌍 Regional Providers

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 13 | **Mistral (15 Models)** 🇫🇷 | `https://api.mistral.ai/v1/` | [Get Key](https://console.mistral.ai/) | `MISTRAL_API_KEY` |
| 14 | **Moonshot** 🇨🇳 | `https://api.moonshot.cn/v1` | [Get Key](https://platform.moonshot.cn/console/api-keys) | `MOONSHOT_API_KEY` |
| 15 | **Qwen** 🇨🇳 | `https://dashscope.aliyuncs.com/compatible-mode/v1` | [Get Key](https://dashscope.console.aliyun.com/apiKey) | `QWEN_API_KEY` |

**Mistral 15 Models (2025):**
- **Featured**: mistral-large-latest, devstral-2, mistral-medium-3.1
- **Frontier**: mistral-small-latest, ministral-3-latest, ministral-3-8b/3b
- **Reasoning**: magistral-medium-latest, magistral-small-latest
- **Coding**: codestral-latest, devstral-small-2, devstral-medium-1.0
- **Specialist**: mistral-small-creative, ocr-3, voxtral-mini

---

### 🔄 Multi-Provider

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 16 | **OpenRouter** | `https://openrouter.ai/api/v1` | [Get Key](https://openrouter.ai/keys) | `OPENROUTER_API_KEY` |

---

### 🧠 AI Agents & Memory

| # | Provider | API Endpoint | Get API Key | Environment Variable |
|---|----------|--------------|-------------|---------------------|
| 17 | **Letta Memory Agent** | `https://api.letta.com/v1/anthropic` | [Get Key](https://app.letta.com/api-keys) | `LETTA_API_KEY` |

**Letta Features:**
- 🧠 **Persistent Memory** - Context across conversations
- 🔄 **5 Backend Options** - Claude Opus/Sonnet/Haiku, GPT-4o, Gemini 2.0 Flash
- 📝 **Memory Blocks** - Stores user preferences and project context
- 🔗 **[Official Docs](https://docs.letta.com/guides/integrations/claude-code-proxy/)**

**Authentication:**
```bash
echo "sk-let-YOUR-KEY" > ~/.letta_api_key
chmod 600 ~/.letta_api_key
```

---

### 🛠️ Management Tools

| # | Tool | Description |
|---|------|-------------|
| 18 | **API Key Manager** | Manage and update all API keys |
| 19 | **Claude Master Tool** | Advanced UI for model management |
| 20 | **API Manager** | Monitor API usage and costs |
| 21 | **Custom API Endpoint** | Any OpenAI-compatible API |

---

## 🔐 API Key Storage

ClaudeAll automatically saves API keys securely:

```bash
~/.minimax_api_key      # MiniMax
~/.gemini_api_key       # Gemini
~/.openai_api_key       # OpenAI
~/.xai_api_key          # xAI/Grok
~/.glm_api_key          # ZhipuAI/GLM
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

All files are created with `chmod 600` for security.

---

## 📚 Usage Examples

### Basic Usage
```bash
# Start interactive menu
claude-all

# Use specific provider
claude-all 1   # MiniMax
claude-all 2   # Gemini
claude-all 3   # Universal OAuth (Auto-Setup)
claude-all 17  # Letta Memory Agent
```

### Universal OAuth (Auto-Setup)
```bash
# Run option 3
claude-all 3

# First time:
# 1. ClaudeAll detects CCS not installed
# 2. Offers to install automatically
# 3. Guides you to authenticate
# 4. Done! Access 37+ OAuth models

# Choose provider:
# 1) Gemini (8 models)
# 2) Codex (18 models - GPT-5.2!)
# 3) GitHub Copilot (Claude Opus 4.5!)
# 4) AntiGravity (6 models)
# 5) Kiro AWS
```

### Letta Memory Agent
```bash
# Setup (one time)
echo "sk-let-YOUR-KEY" > ~/.letta_api_key
chmod 600 ~/.letta_api_key

# Run
claude-all 17

# Choose backend:
# 1) Opus    - Most Powerful
# 2) Sonnet  - Balanced (Recommended)
# 3) Haiku   - Fastest
# 4) GPT-4o  - OpenAI
# 5) Gemini  - Google Gemini 2.0 Flash
```

---

## 🔧 Environment Variables

### Set API Keys via Environment

```bash
# Quick Access Models
export MINIMAX_API_KEY="your-minimax-key"
export GEMINI_API_KEY="your-gemini-key"
export OPENAI_API_KEY="your-openai-key"

# Cloud Providers
export XAI_API_KEY="your-xai-key"
export GLM_API_KEY="your-glm-key"
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

### Letta Authentication

```bash
# Set environment variables
export ANTHROPIC_AUTH_TOKEN="sk-let-YOUR-KEY"
export ANTHROPIC_BASE_URL="https://api.letta.com/v1/anthropic"

# Or let ClaudeAll auto-load from file
echo "sk-let-YOUR-KEY" > ~/.letta_api_key
chmod 600 ~/.letta_api_key
```

---

## 🌐 Cross-Platform Support

✅ **Linux** (Ubuntu, Debian, CentOS, Arch, Fedora)
✅ **macOS** (Intel & Apple Silicon)
✅ **Windows** (WSL2, PowerShell, Git Bash)
✅ **Termux** (Android) ⭐ **Fully Tested!**
✅ **FreeBSD/OpenBSD**
✅ **SunOS/Solaris**

---

## 📊 Package Information

- **Package Name**: `claude-all-ai-launcher`
- **Version**: 8.4.1
- **License**: MIT
- **Node.js Required**: >=14.0.0
- **Repository**: [github.com/zesbe/ClaudeAll](https://github.com/zesbe/ClaudeAll)
- **NPM Package**: [claude-all-ai-launcher](https://www.npmjs.com/package/claude-all-ai-launcher)

---

## 📖 Documentation

- **[OAuth Auto-Setup Guide](OAUTH-AUTO-SETUP.md)** - Complete Universal OAuth guide
- **[Installation Guide](docs/)** - Detailed installation instructions
- **[Provider Setup](docs/providers.md)** - AI provider configuration
- **[API Reference](docs/api.md)** - Command reference
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues

---

## 🆘 Support

- **[GitHub Issues](https://github.com/zesbe/ClaudeAll/issues)** - Bug reports and feature requests
- **[GitHub Discussions](https://github.com/zesbe/ClaudeAll/discussions)** - Community help
- **[GitHub Wiki](https://github.com/zesbe/ClaudeAll/wiki)** - Additional guides
- **[Discord](https://discord.gg/letta)** - Letta Community

---

## 🚀 Why ClaudeAll?

- **🌍 Universal**: One tool for 23+ providers and 60+ models
- **⚡ Fast**: Optimized for speed and efficiency
- **🛡️ Reliable**: Built-in error handling and retries
- **🎯 Simple**: Easy installation and configuration
- **🔧 Powerful**: Advanced features for power users
- **📱 Cross-Platform**: Works everywhere Node.js runs
- **🚀 Auto-Setup**: CCS OAuth installed automatically
- **🔐 Secure**: API keys stored with chmod 600

---

## 📝 Changelog

### v8.4.1 (2024-12-31)
- ✨ **NEW**: Auto-installer for CCS OAuth (Option 3)
- ✨ **NEW**: Zero-config Universal OAuth setup
- 🎯 Guided authentication flow in Bahasa Indonesia
- 📝 Complete OAuth documentation

### v8.4.0 (2024-12-31)
- ✨ **NEW**: Universal OAuth with 37+ models (GPT-5, Claude Opus 4.5, Gemini 3)
- ✨ **NEW**: Mistral 15 models (2025 latest)
- 🐛 **FIX**: Letta Memory Agent AUTH_TOKEN authentication
- 📝 Updated documentation with OAuth guide

### v8.3.1 (2024-12-30)
- 📝 Updated README with OAuth & Letta documentation
- 🔧 Improved API key management

### v8.3.0 (2024-12-30)
- ✨ Added Letta Memory Agent (Option 17)
- 🐛 Bug fixes and improvements

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🎊 Summary

**ClaudeAll v8.4.1** = One Tool. Zero Hassle. 60+ Models. Auto-Everything! 🚀

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  ✅ 23+ AI Providers                                        │
│  ✅ 60+ Models (including OAuth)                            │
│  ✅ Auto-Install CCS (30 seconds)                           │
│  ✅ Secure API Key Storage                                  │
│  ✅ Cross-Platform Support                                  │
│  ✅ Bahasa Indonesia Support                                │
│                                                              │
│  Made with ❤️  by zesbe                                     │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

*Experience the future of AI interaction with ClaudeAll!* 🌟
