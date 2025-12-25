#!/usr/bin/env node

/**
 * 🤖 Claude-All Post-Installation Script
 */

const fs = require('fs');
const path = require('path');

class PostInstall {
    constructor() {
        this.homeDir = require('os').homedir();
        this.installDir = path.join(this.homeDir, '.claude-all');
    }

    showWelcome() {
        console.log('');
        console.log('🎉 Welcome to Claude-All AI Launcher!');
        console.log('===================================');
        console.log('');
        console.log('🚀 Quick Start Commands:');
        console.log('  claude-all              # Start AI launcher');
        console.log('  ai-chat                 # Start chat interface');
        console.log('  npm run claude         # Start via NPM');
        console.log('  npm run switch         # Switch AI provider');
        console.log('');
        console.log('🔧 First-Time Setup:');
        console.log('  npm run config         # Configure API keys');
        console.log('  claude-all --help      # Show all options');
        console.log('');
        console.log('📱 Available AI Providers:');
        console.log('  • MiniMax • Gemini • OpenAI • Groq • Ollama');
        console.log('');
        console.log('Enjoy your universal AI assistant! 🤖');
    }

    run() {
        this.showWelcome();
    }
}

if (require.main === module) {
    new PostInstall().run();
}

module.exports = PostInstall;