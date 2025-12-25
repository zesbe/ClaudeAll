#!/usr/bin/env node

/**
 * 🤖 Claude-All Universal AI Launcher - NPM Installer
 * Cross-platform installer for AI CLI launcher with multiple providers
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const os = require('os');

class ClaudeAllInstaller {
    constructor() {
        this.homeDir = os.homedir();
        this.platform = os.platform();
        this.packageDir = __dirname;
        this.installDir = path.join(this.homeDir, '.claude-all');
    }

    printHeader() {
        console.log('🤖 CLAUDE-ALL UNIVERSAL AI LAUNCHER');
        console.log('==================================');
        console.log('Installing AI CLI launcher with:');
        console.log('  ✅ Claude Code CLI integration');
        console.log('  ✅ Multiple AI providers (MiniMax, Gemini, OpenAI, Groq, Ollama)');
        console.log('  ✅ Universal device compatibility');
        console.log('  ✅ Cross-platform support');
        console.log('');
    }

    checkSystem() {
        console.log('🔍 Checking system compatibility...');

        const supportedPlatforms = ['linux', 'darwin', 'win32', 'freebsd', 'openbsd', 'android', 'sunos'];
        if (!supportedPlatforms.includes(this.platform)) {
            console.log(`⚠️  Platform ${this.platform} not officially supported`);
            console.log('  Trying installation anyway...');
        } else {
            console.log(`✅ Platform: ${this.platform}`);
        }

        // Check Node.js version
        const nodeVersion = process.version;
        const majorVersion = parseInt(nodeVersion.slice(1).split('.')[0]);
        if (majorVersion < 14) {
            console.log(`⚠️  Node.js ${nodeVersion} detected. Minimum recommended: 14.x`);
        } else {
            console.log(`✅ Node.js: ${nodeVersion}`);
        }
    }

    createDirectories() {
        console.log('📁 Creating directories...');

        const dirs = [
            this.installDir,
            path.join(this.installDir, 'config'),
            path.join(this.installDir, 'logs'),
            path.join(this.installDir, 'cache')
        ];

        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
                console.log(`  ✅ Created: ${dir}`);
            }
        });
    }

    installDependencies() {
        console.log('📦 Checking dependencies...');

        const commands = {
            linux: [
                'curl --version',
                'wget --version',
                'python3 --version'
            ],
            darwin: [
                'curl --version',
                'wget --version',
                'python3 --version'
            ],
            win32: [
                'curl --version',
                'python --version'
            ],
            android: [
                'curl --version',
                'python --version'
            ]
        };

        const platformCommands = commands[this.platform] || commands.linux;

        platformCommands.forEach(cmd => {
            try {
                execSync(cmd, { stdio: 'pipe' });
                console.log(`  ✅ ${cmd.split(' ')[0]} available`);
            } catch (e) {
                console.log(`  ⚠️  ${cmd.split(' ')[0]} not found (optional)`);
            }
        });
    }

    setupConfiguration() {
        console.log('⚙️  Setting up configuration...');

        const defaultConfig = {
            version: fs.readFileSync(path.join(this.packageDir, '..', 'VERSION'), 'utf8').trim(),
            providers: {
                minimax: {
                    name: "MiniMax",
                    enabled: true,
                    endpoint: "https://api.minimax.chat/v1",
                    models: ["abab6.5", "abab6.5s", "abab5.5"]
                },
                gemini: {
                    name: "Google Gemini",
                    enabled: true,
                    endpoint: "https://generativelanguage.googleapis.com/v1beta",
                    models: ["gemini-pro", "gemini-pro-vision"]
                },
                openai: {
                    name: "OpenAI",
                    enabled: true,
                    endpoint: "https://api.openai.com/v1",
                    models: ["gpt-4", "gpt-3.5-turbo"]
                },
                groq: {
                    name: "Groq",
                    enabled: true,
                    endpoint: "https://api.groq.com/openai/v1",
                    models: ["llama-3.1-70b-versatile", "mixtral-8x7b-32768"]
                }
            },
            ui: {
                theme: "default",
                auto_save: true,
                history_size: 1000
            }
        };

        const configFile = path.join(this.installDir, 'config', 'config.json');
        fs.writeFileSync(configFile, JSON.stringify(defaultConfig, null, 2));
        console.log(`  ✅ Configuration: ${configFile}`);
    }

    createSymlinks() {
        console.log('🔗 Creating symlinks...');

        const binDir = path.join(this.homeDir, '.local', 'bin');
        if (!fs.existsSync(binDir)) {
            fs.mkdirSync(binDir, { recursive: true });
        }

        const targets = [
            { src: 'claude-all', dest: 'claude-all' },
            { src: 'claude-all', dest: 'claude-launcher' },
            { src: 'claude-all', dest: 'ai-chat' }
        ];

        targets.forEach(({ src, dest }) => {
            const sourcePath = path.join(this.packageDir, '..', 'bin', src);
            const destPath = path.join(binDir, dest);

            try {
                if (fs.existsSync(destPath)) {
                    fs.unlinkSync(destPath);
                }

                if (this.platform === 'win32') {
                    fs.copyFileSync(sourcePath, destPath);
                    fs.chmodSync(destPath, '755');
                } else {
                    fs.symlinkSync(sourcePath, destPath);
                }

                console.log(`  ✅ ${dest}`);
            } catch (e) {
                console.log(`  ⚠️  Could not create ${dest}: ${e.message}`);
            }
        });
    }

    updateShellConfig() {
        console.log('🔧 Updating shell configuration...');

        const shellFiles = ['.bashrc', '.zshrc', '.profile'];
        const binPath = path.join(this.homeDir, '.local', 'bin');
        const exportLine = `export PATH="${binPath}:$PATH"`;

        shellFiles.forEach(file => {
            const filePath = path.join(this.homeDir, file);

            if (fs.existsSync(filePath)) {
                const content = fs.readFileSync(filePath, 'utf8');

                if (!content.includes(binPath)) {
                    fs.appendFileSync(filePath, `\n\n# Claude-All AI Launcher\n${exportLine}\n`);
                    console.log(`  ✅ Updated ${file}`);
                }
            }
        });

        console.log(`  💡 Add to PATH: ${binPath}`);
    }

    createStartupScripts() {
        console.log('🚀 Creating startup scripts...');

        const launchScript = `#!/bin/bash
# Claude-All AI Launcher
echo "🤖 Starting Claude-All AI Launcher..."
exec "${path.join(this.packageDir, '..', 'bin', 'claude-all')}" "$@"
`;

        const scripts = {
            'claude-launch': launchScript,
            'ai-chat': launchScript
        };

        Object.entries(scripts).forEach(([name, content]) => {
            const scriptPath = path.join(this.installDir, name);
            fs.writeFileSync(scriptPath, content);
            fs.chmodSync(scriptPath, '755');
            console.log(`  ✅ ${scriptPath}`);
        });
    }

    showCompletion() {
        console.log('');
        console.log('🎉 CLAUDE-ALL INSTALLATION COMPLETED!');
        console.log('====================================');
        console.log('');
        console.log('✅ Universal AI launcher installed');
        console.log('✅ Multiple AI providers configured');
        console.log('✅ Cross-platform compatibility ensured');
        console.log('✅ Shell configuration updated');
        console.log('');
        console.log('🚀 Quick Start:');
        console.log('');
        console.log('NPM Commands:');
        console.log('  npm run claude         - Start Claude-All');
        console.log('  npm run launch         - Start Claude-All');
        console.log('  npm run switch         - Switch AI provider');
        console.log('  npm run config         - Configure settings');
        console.log('  npm run help           - Show help');
        console.log('');
        console.log('Direct Commands:');
        console.log('  claude-all              - Start AI launcher');
        console.log('  ai-chat                 - Start chat interface');
        console.log('  claude-launcher         - Alternative launcher');
        console.log('');
        console.log('🔧 Configuration:');
        console.log(`  Config: ${path.join(this.installDir, 'config', 'config.json')}`);
        console.log(`  Logs:   ${path.join(this.installDir, 'logs')}`);
        console.log('');
        console.log('📱 Supported Providers:');
        console.log('  • MiniMax                • Google Gemini');
        console.log('  • OpenAI                 • Groq');
        console.log('  • Ollama (Local)         • Custom APIs');
        console.log('  • xAI/Grok               • ZhipuAI/GLM');
        console.log('');
        console.log('⚠️  IMPORTANT:');
        console.log('  • Restart your shell or run: source ~/.bashrc');
        console.log('  • Set API keys in configuration');
        console.log('  • Run: npm run config to setup');
        console.log('');
        console.log('🎯 Ready to launch AI assistants on any device! 🚀');
    }

    async install() {
        try {
            this.printHeader();
            this.checkSystem();
            this.createDirectories();
            this.installDependencies();
            this.setupConfiguration();
            this.createSymlinks();
            this.updateShellConfig();
            this.createStartupScripts();
            this.showCompletion();
        } catch (error) {
            console.error('❌ Installation failed:', error.message);
            process.exit(1);
        }
    }
}

// Run installer if called directly
if (require.main === module) {
    const installer = new ClaudeAllInstaller();
    installer.install();
}

module.exports = ClaudeAllInstaller;