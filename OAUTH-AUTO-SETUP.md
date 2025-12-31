# 🚀 Universal OAuth Auto-Setup Guide

## ClaudeAll v8.4.1 - Zero-Config OAuth!

ClaudeAll sekarang **automatically installs CCS** jika belum ada. Tidak perlu ribet lagi! 🎊

---

## 🎯 **Untuk User Baru (Belum Install CCS)**

### Step-by-Step:

```bash
# 1. Jalankan ClaudeAll
claude-all

# 2. Pilih Option 3 (Universal OAuth)
# Ketik: 3 [Enter]

# 3. Pilih Provider (contoh: AntiGravity)
# Ketik: 4 [Enter]

# 4. ClaudeAll akan detect CCS belum terinstall:
# ⚠️  CCS (Claude Code Switch) belum terinstall
# 
# CCS diperlukan untuk Universal OAuth (GPT-5, Claude Opus 4.5, Gemini 3)
# 
# Install CCS akan:
#   • Download @kaitranntt/ccs via npm
#   • Ukuran: ~10MB
#   • Waktu: ~30 detik
# 
# Install CCS sekarang? [Y/n]: 

# 5. Ketik Y [Enter]
# ClaudeAll akan auto-install CCS!

# 6. Setelah install, ClaudeAll tanya:
# Authenticate sekarang? [Y/n]:

# 7. Ketik Y [Enter]
# Browser akan terbuka untuk login (Google/GitHub/etc)

# 8. Selesai! Mulai chat dengan GPT-5, Claude Opus 4.5, Gemini 3!
```

---

## 🎊 **Untuk User yang Sudah Punya CCS**

ClaudeAll akan auto-detect dan skip installation:

```bash
claude-all

# Pilih: 3 (Universal OAuth)
# Pilih: 4 (AntiGravity)

# Output:
# ✓ CCS sudah terinstall
# 🔥 AntiGravity (Anthropic via CCS OAuth)
# 
# Pilih Model:
#   1) gemini-claude-opus-4-5-thinking  (Most Capable - Thinking) [RECOMMENDED]
#   2) gemini-3-flash-preview          (Next Gen - Fast)
#   ...

# Langsung pilih model dan mulai chat!
```

---

## 📊 **Available Providers & Models**

### 1️⃣ **Gemini (Google)** - 8 Models
- gemini-2.5-pro (Recommended)
- gemini-2.5-flash
- gemini-2.5-flash-lite
- gemini-3-pro-preview 🔥
- gemini-3-flash-preview
- gemini-2.0-flash-exp
- gemini-1.5-pro
- gemini-1.5-flash

**Authentication:**
```bash
ccs gemini --auth
```

---

### 2️⃣ **Codex (OpenAI)** - 18 Models 🤖
#### GPT 5.2 Series (Latest 🔥):
- gpt-5.2 (Recommended)
- gpt-5.2-pro
- gpt-5.2-chat-latest

#### GPT 5.1 Series:
- gpt-5.1-codex-max
- gpt-5.1-codex
- gpt-5.1
- gpt-5.1-codex-mini
- gpt-5.1-chat-latest

#### GPT 5 Series:
- gpt-5
- gpt-5-pro
- gpt-5-codex
- gpt-5-chat-latest

#### Legacy (GPT 4):
- gpt-4o
- gpt-4o-mini
- gpt-4-turbo
- o1-preview
- o1-mini
- o1-pro

**Authentication:**
```bash
ccs codex --auth
```

---

### 3️⃣ **GitHub Copilot** - 4 Models 💻
- claude-opus-4.5 (Recommended)
- claude-sonnet-4.5
- gpt-4o
- gpt-5.1

**Requirements:**
```bash
npm install -g copilot-api
ccs copilot --auth
```

---

### 4️⃣ **AntiGravity (Anthropic)** - 6 Models 🔥
- gemini-claude-opus-4-5-thinking (Recommended)
- gemini-3-flash-preview
- gemini-2.5-pro
- gemini-2.5-flash
- claude-opus-4.2
- claude-sonnet-4.2

**Authentication:**
```bash
ccs agy --auth
```

---

### 5️⃣ **Kiro (AWS)** - AWS Claude Models ☁️
AWS-hosted Claude models via CodeWhisperer.

**Authentication:**
```bash
ccs kiro --auth
```

---

## 🛠️ **Troubleshooting**

### Problem: CCS install failed

**Solution 1: Clean npm cache**
```bash
npm cache clean --force
npm install -g @kaitranntt/ccs
```

**Solution 2: Check internet connection**
```bash
ping google.com
```

**Solution 3: Manual install**
```bash
npm install -g @kaitranntt/ccs
```

### Problem: Authentication failed

**Solution: Re-authenticate**
```bash
# Logout first
ccs gemini --logout

# Then re-authenticate
ccs gemini --auth
```

### Problem: Model not responding

**Solution: Check account**
```bash
# List all accounts
ccs gemini --accounts

# Switch account if needed
ccs gemini --use <account-name>
```

---

## 🎯 **Key Benefits**

✅ **Zero Manual Setup**: Auto-install + auto-configure
✅ **User-Friendly**: Guided prompts in Bahasa Indonesia
✅ **Time-Saving**: 30 seconds vs 5+ minutes manual setup
✅ **Beginner-Friendly**: No CLI/npm knowledge needed
✅ **37+ Models**: Access to GPT-5, Claude Opus 4.5, Gemini 3
✅ **One ClaudeAll**: No need for separate CCS repo

---

## 📝 **Summary**

**BEFORE (Manual Setup):**
```bash
# User needs to:
1. npm install -g @kaitranntt/ccs
2. ccs <provider> --auth
3. claude-all 3
4. Choose provider
5. Start chatting

Total: ~5 minutes, 4 commands
```

**AFTER (Auto-Setup):**
```bash
# User only needs:
1. claude-all 3
2. Press Y (install CCS)
3. Press Y (authenticate)
4. Start chatting!

Total: ~30 seconds, 1 command + 2 confirmations
```

---

## 🚀 **Made with ClaudeAll v8.4.1**

**One repo. Zero hassle. 37+ models. Auto-everything!** 🎊
