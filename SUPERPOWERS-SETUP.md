# 🦸 Claude-All Superpowers - Quick Setup Guide

## ✨ What's New

Claude-All sekarang **otomatis menginstall** semua superpowers (skills, commands, agents, hooks) ke Claude Code saat Anda menjalankan `npm install`!

## 🚀 Cara Install

### Method 1: Install dari Local Repository

```bash
cd ~/projects/ClaudeAll
npm install
```

**Secara otomatis akan menginstall:**
- ✅ **30+ Skills** - API development, debugging, testing, dll
- ✅ **13 Agents** - Code reviewer, doc generator, test generator, dll
- ✅ **3 Commands** - /brainstorm, /execute-plan, /write-plan
- ✅ **3 Hooks** - Git hooks automation
- ✅ **Libraries** - Helper functions

### Method 2: Install Superpowers Only

```bash
cd ~/projects/ClaudeAll
npm run install-superpowers
```

### Method 3: Install dari NPM (Coming Soon)

```bash
npm install -g claude-all-ai-launcher
```

## 📍 Lokasi Installation

Semua superpowers diinstall ke:
```
~/.claude/plugins/claude-all-superpowers/
├── skills/          # 30+ specialized skills
├── agents/          # 13 specialized agents
├── hooks/           # Git hooks
├── lib/             # Helper libraries
└── manifest.json    # Installation manifest
```

Commands juga diinstall ke:
```
~/.claude/commands/
├── brainstorm.md
├── execute-plan.md
└── write-plan.md
```

## 🧹 Cara Uninstall

```bash
cd ~/projects/ClaudeAll
npm run uninstall-superpowers
```

## 📚 Daftar Superpowers

### Skills (30 total)
- **Development**: api-development, database-development, mobile-development
- **Testing**: integration-testing, test-driven-development, testing-anti-patterns
- **Quality**: code-review, refactoring, security-review
- **Planning**: writing-plans, executing-plans, brainstorming
- **Debugging**: systematic-debugging, root-cause-tracing
- **Documentation**: documentation-generation
- **Performance**: performance-optimization
- **Deployment**: deployment
- **Dan banyak lagi...**

### Agents (13 total)
- `accessibility-reviewer` - Review accessibility
- `ai-prompt-optimizer` - Optimize AI prompts
- `api-tester` - Test API endpoints
- `code-generator` - Generate code
- `code-reviewer` - Review code
- `component-generator` - Generate components
- `doc-generator` - Generate documentation
- `migration-generator` - Generate migrations
- `performance-analyzer` - Analyze performance
- `readme-generator` - Generate README
- `security-auditor` - Audit security
- `terraform-generator` - Generate Terraform
- `test-generator` - Generate tests

### Commands (3 total)
- `/brainstorm` - Brainstorming session
- `/execute-plan` - Execute development plan
- `/write-plan` - Write development plan

## 💡 Penggunaan

### Restart Claude Code
Setelah install, **restart Claude Code** untuk memuat superpowers:

```bash
# Exit Claude Code dan restart
claude
```

### Menggunakan Commands
```bash
# Dalam Claude Code
/brainstorm
/execute-plan
/write-plan
```

### Menggunakan Skills
Skills akan otomatis tersedia dan dapat dipanggil oleh Claude sesuai kebutuhan.

## 🔄 Update Superpowers

```bash
cd ~/projects/ClaudeAll
git pull origin main
npm run install-superpowers
```

## 🐛 Troubleshooting

### Superpowers tidak muncul?
```bash
# Reinstall
cd ~/projects/ClaudeAll
npm run uninstall-superpowers
npm run install-superpowers

# Restart Claude Code
```

### Cek installation
```bash
cat ~/.claude/plugins/claude-all-superpowers/manifest.json
```

### Lihat installed skills
```bash
ls ~/.claude/plugins/claude-all-superpowers/skills/
```

## 📖 More Info

- **Repository**: https://github.com/zesbe/ClaudeAll
- **NPM Package**: https://www.npmjs.com/package/claude-all-ai-launcher
- **Documentation**: https://github.com/zesbe/ClaudeAll/blob/main/README.md

---

**Made with ❤️ by zesbe**
