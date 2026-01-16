#!/usr/bin/env node

/**
 * 🗑️ Claude-All Superpowers Uninstaller
 * Menghapus superpowers dari Claude Code
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

class SuperpowersUninstaller {
    constructor() {
        this.homeDir = os.homedir();
        this.claudeDir = path.join(this.homeDir, '.claude');
        this.claudePluginsDir = path.join(this.claudeDir, 'plugins', 'claude-all-superpowers');
    }

    printHeader() {
        console.log('');
        console.log('🗑️ CLAUDE-ALL SUPERPOWERS UNINSTALLER');
        console.log('====================================');
        console.log('');
    }

    checkInstalled() {
        console.log('🔍 Checking installation...');

        if (!fs.existsSync(this.claudePluginsDir)) {
            console.log('⚠️  No superpowers installation found');
            return false;
        }

        console.log(`✅ Found installation: ${this.claudePluginsDir}`);
        return true;
    }

    removeDirectory(dir) {
        if (!fs.existsSync(dir)) {
            return;
        }

        const remove = (directory) => {
            const items = fs.readdirSync(directory);

            items.forEach(item => {
                const fullPath = path.join(directory, item);
                const stat = fs.statSync(fullPath);

                if (stat.isDirectory()) {
                    remove(fullPath);
                    fs.rmdirSync(fullPath);
                } else {
                    fs.unlinkSync(fullPath);
                }
            });
        };

        remove(dir);
        fs.rmdirSync(dir);
    }

    removeCommands() {
        console.log('');
        console.log('🗑️  Removing commands...');

        const commandsDir = path.join(this.claudeDir, 'commands');

        if (!fs.existsSync(commandsDir)) {
            console.log('  ⚠️  No commands directory found');
            return;
        }

        // Read manifest if exists to identify which commands were installed
        const manifestPath = path.join(this.claudePluginsDir, 'manifest.json');
        let installedCommands = [];

        if (fs.existsSync(manifestPath)) {
            try {
                const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
                // Could track installed commands in manifest
            } catch (e) {
                // Ignore
            }
        }

        // For now, remove all claude-all related commands
        const commands = fs.readdirSync(commandsDir).filter(f => {
            // You might want to be more specific about which commands to remove
            return f.startsWith('claude-') || f.startsWith('git-') || f.startsWith('gen-');
        });

        let count = 0;
        commands.forEach(cmd => {
            const cmdPath = path.join(commandsDir, cmd);
            fs.unlinkSync(cmdPath);
            console.log(`  ✅ Removed: ${cmd}`);
            count++;
        });

        if (count === 0) {
            console.log('  ℹ️  No claude-all commands to remove');
        } else {
            console.log(`📊 Removed ${count} commands`);
        }
    }

    uninstall() {
        try {
            this.printHeader();

            if (!this.checkInstalled()) {
                console.log('');
                console.log('ℹ️  Nothing to uninstall');
                return;
            }

            // Remove commands first
            this.removeCommands();

            // Remove main plugin directory
            console.log('');
            console.log('🗑️  Removing superpowers directory...');
            this.removeDirectory(this.claudePluginsDir);
            console.log(`  ✅ Removed: ${this.claudePluginsDir}`);

            console.log('');
            console.log('🎉 UNINSTALLATION COMPLETED!');
            console.log('=========================');
            console.log('');
            console.log('✅ Superpowers removed from Claude Code');
            console.log('');
            console.log('💡 Note: You may need to restart Claude Code');

        } catch (error) {
            console.error('');
            console.error('❌ Uninstallation failed:', error.message);
            console.error(error.stack);
            process.exit(1);
        }
    }
}

// Run uninstaller if called directly
if (require.main === module) {
    const uninstaller = new SuperpowersUninstaller();
    uninstaller.uninstall();
}

module.exports = SuperpowersUninstaller;
