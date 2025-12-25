#!/usr/bin/env node

/**
 * 🤖 Claude-All Help System
 */

class HelpCommand {
    constructor() {
        this.version = '8.1.0';
    }

    showGeneralHelp() {
        console.log('🤖 CLAUDE-ALL UNIVERSAL AI LAUNCHER');
        console.log('==================================');
        console.log(`Version: ${this.version}`);
        console.log('');
        console.log('📦 NPM Commands:');
        console.log('  npm run claude         - Start Claude-All AI launcher');
        console.log('  npm run launch         - Alternative launcher');
        console.log('  npm run switch         - Switch AI provider');
        console.log('  npm run config         - Configure settings');
        console.log('  npm run status         - Show status');
        console.log('  npm run update         - Update installation');
        console.log('  npm run help           - Show this help');
        console.log('  npm run doctor         - Troubleshoot issues');
        console.log('  npm run test           - Run tests');
        console.log('  npm run uninstall      - Uninstall Claude-All');
        console.log('');
        console.log('🚀 Direct Commands:');
        console.log('  claude-all              # Start AI launcher');
        console.log('  ai-chat                 # Start chat interface');
        console.log('  claude-launcher         # Alternative launcher');
        console.log('');
        this.showProviderInfo();
    }

    showProviderInfo() {
        console.log('🔌 AI Providers:');
        console.log('  • MiniMax     - High-performance Chinese AI');
        console.log('  • Gemini      - Google Gemini AI Studio');
        console.log('  • OpenAI      - GPT-4 and GPT-3.5');
        console.log('  • Groq        - Ultra-fast inference');
        console.log('  • Ollama      - Local LLM hosting');
        console.log('  • xAI/Grok    - xAI Grok models');
        console.log('  • ZhipuAI     - GLM series models');
        console.log('  • Custom      - Any REST API endpoint');
        console.log('');
        console.log('⚙️  Configuration:');
        console.log('  npm run config         # Interactive setup');
        console.log('  ~/.claude-all/config/   # Configuration directory');
        console.log('');
        console.log('📚 Documentation:');
        console.log('  https://github.com/zesbe/ClaudeAll#readme');
        console.log('');
        console.log('❓ Need Help?');
        console.log('  Run: npm run doctor     # Troubleshooting');
        console.log('  Issues: https://github.com/zesbe/ClaudeAll/issues');
    }

    showConfigHelp() {
        console.log('⚙️  Configuration Guide');
        console.log('=====================');
        console.log('');
        console.log('🔧 Interactive Config:');
        console.log('  npm run config         # Start configuration wizard');
        console.log('');
        console.log('📝 Manual Config:');
        console.log('  File: ~/.claude-all/config/config.json');
        console.log('');
        console.log('🔑 API Keys Setup:');
        console.log('  • MiniMax: Set in config or environment variable');
        console.log('  • Gemini: Set GOOGLE_GENAI_API_KEY');
        console.log('  • OpenAI: Set OPENAI_API_KEY');
        console.log('  • Groq: Set GROQ_API_KEY');
        console.log('');
        console.log('💡 Tip: Run "npm run doctor" to check configuration');
    }

    showDoctorHelp() {
        console.log('🩺 Claude-All Doctor');
        console.log('==================');
        console.log('');
        console.log('🔍 Common Issues:');
        console.log('');
        console.log('❌ Command not found:');
        console.log('  • Restart shell or run: source ~/.bashrc');
        console.log('  • Check PATH includes ~/.local/bin');
        console.log('');
        console.log('❌ API Key errors:');
        console.log('  • Run: npm run config');
        console.log('  • Check environment variables');
        console.log('');
        console.log('❌ Connection issues:');
        console.log('  • Test with: curl -I https://api.openai.com');
        console.log('  • Check firewall/proxy settings');
        console.log('');
        console.log('🔧 Auto-Fix:');
        console.log('  npm run config         # Reconfigure');
        console.log('  npm run update         # Update installation');
        console.log('  npm run doctor         # Full diagnostic');
    }
}

function main() {
    const args = process.argv.slice(2);
    const help = new HelpCommand();

    if (args.length === 0 || args[0] === 'general') {
        help.showGeneralHelp();
    } else if (args[0] === 'config') {
        help.showConfigHelp();
    } else if (args[0] === 'doctor') {
        help.showDoctorHelp();
    } else {
        console.log('❌ Unknown help topic:', args[0]);
        console.log('Available topics: general, config, doctor');
        help.showGeneralHelp();
    }
}

if (require.main === module) {
    main();
}

module.exports = HelpCommand;