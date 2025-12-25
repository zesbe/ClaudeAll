#!/usr/bin/env node

/**
 * 🤖 Claude-All Configuration Manager
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

class ConfigManager {
    constructor() {
        this.homeDir = require('os').homedir();
        this.configDir = path.join(this.homeDir, '.claude-all', 'config');
        this.configFile = path.join(this.configDir, 'config.json');
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    async question(prompt) {
        return new Promise((resolve) => {
            this.rl.question(prompt, resolve);
        });
    }

    loadConfig() {
        if (fs.existsSync(this.configFile)) {
            return JSON.parse(fs.readFileSync(this.configFile, 'utf8'));
        }
        return this.getDefaultConfig();
    }

    getDefaultConfig() {
        return {
            version: "8.1.0",
            providers: {
                minimax: {
                    name: "MiniMax",
                    enabled: true,
                    endpoint: "https://api.minimax.chat/v1",
                    models: ["abab6.5", "abab6.5s", "abab5.5"],
                    api_key: ""
                },
                gemini: {
                    name: "Google Gemini",
                    enabled: true,
                    endpoint: "https://generativelanguage.googleapis.com/v1beta",
                    models: ["gemini-pro", "gemini-pro-vision"],
                    api_key: ""
                },
                openai: {
                    name: "OpenAI",
                    enabled: true,
                    endpoint: "https://api.openai.com/v1",
                    models: ["gpt-4", "gpt-3.5-turbo"],
                    api_key: ""
                },
                groq: {
                    name: "Groq",
                    enabled: true,
                    endpoint: "https://api.groq.com/openai/v1",
                    models: ["llama-3.1-70b-versatile", "mixtral-8x7b-32768"],
                    api_key: ""
                }
            },
            ui: {
                theme: "default",
                auto_save: true,
                history_size: 1000
            },
            default_provider: "minimax"
        };
    }

    async setupProvider(providerName, providerConfig) {
        console.log(`\n🔧 Configuring ${providerConfig.name}...`);

        const enable = await this.question(`Enable ${providerConfig.name}? (Y/n): `);
        providerConfig.enabled = enable.toLowerCase() !== 'n';

        if (providerConfig.enabled) {
            const apiKey = await this.question('Enter API key (leave empty for environment variable): ');
            providerConfig.api_key = apiKey;

            if (providerConfig.models.length > 1) {
                console.log('Available models:');
                providerConfig.models.forEach((model, i) => {
                    console.log(`  ${i + 1}. ${model}`);
                });

                const modelChoice = await this.question('Select model (number or name): ');
                providerConfig.default_model = providerConfig.models[modelChoice - 1] || modelChoice;
            }
        }
    }

    async interactiveSetup() {
        console.log('🤖 Claude-All Configuration Setup');
        console.log('==================================');

        let config = this.loadConfig();

        for (const [key, provider] of Object.entries(config.providers)) {
            await this.setupProvider(key, provider);
        }

        // Set default provider
        const enabledProviders = Object.entries(config.providers)
            .filter(([_, p]) => p.enabled)
            .map(([k, _]) => k);

        if (enabledProviders.length > 0) {
            console.log('\nAvailable providers:');
            enabledProviders.forEach((p, i) => {
                console.log(`  ${i + 1}. ${config.providers[p].name}`);
            });

            const defaultChoice = await this.question('Select default provider (number): ');
            config.default_provider = enabledProviders[defaultChoice - 1];
        }

        // UI settings
        console.log('\n🎨 UI Configuration');
        const theme = await this.question('Theme (default/dark/light): ') || 'default';
        config.ui.theme = theme;

        const autoSave = await this.question('Enable auto-save? (Y/n): ');
        config.ui.auto_save = autoSave.toLowerCase() !== 'n';

        // Save configuration
        fs.writeFileSync(this.configFile, JSON.stringify(config, null, 2));

        console.log('\n✅ Configuration saved!');
        console.log(`📁 Location: ${this.configFile}`);
    }

    showCurrentConfig() {
        const config = this.loadConfig();

        console.log('⚙️  Current Configuration');
        console.log('========================');
        console.log(`Version: ${config.version}`);
        console.log(`Default Provider: ${config.default_provider}`);
        console.log('');

        console.log('🔌 Providers:');
        for (const [key, provider] of Object.entries(config.providers)) {
            const status = provider.enabled ? '✅' : '❌';
            const keyStatus = provider.api_key ? '🔑' : '❌';
            console.log(`  ${status} ${keyStatus} ${provider.name}`);
            if (provider.default_model) {
                console.log(`     Default: ${provider.default_model}`);
            }
        }

        console.log('\n🎨 UI Settings:');
        console.log(`  Theme: ${config.ui.theme}`);
        console.log(`  Auto-save: ${config.ui.auto_save ? 'Enabled' : 'Disabled'}`);
    }

    async run() {
        const mode = process.argv[2] || 'interactive';

        if (mode === 'show') {
            this.showCurrentConfig();
        } else if (mode === 'interactive') {
            await this.interactiveSetup();
        } else {
            console.log('Usage: npm run config [show|interactive]');
            console.log('  show       - Show current configuration');
            console.log('  interactive - Interactive setup wizard');
        }
    }
}

if (require.main === module) {
    const config = new ConfigManager();
    config.run().finally(() => {
        config.rl.close();
    });
}

module.exports = ConfigManager;