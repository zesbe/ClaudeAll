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
        this.claudeGlobalSkillsDir = path.join(this.claudeDir, 'skills');
        this.claudeGlobalAgentsDir = path.join(this.claudeDir, 'agents');
        this.claudeHooksDir = path.join(this.claudeDir, 'hooks');
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

        // Remove all claude-all related commands
        const commands = fs.readdirSync(commandsDir).filter(f => {
            return f.startsWith('claude-') || f.startsWith('git-') || f.startsWith('gen-') ||
                   f === 'brainstorm.md' || f === 'execute-plan.md' || f === 'write-plan.md';
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

    removeAgents() {
        console.log('');
        console.log('🗑️  Removing global agents...');

        if (!fs.existsSync(this.claudeGlobalAgentsDir)) {
            console.log('  ⚠️  No global agents directory found');
            return;
        }

        // Remove all agents from global folder
        const agents = fs.readdirSync(this.claudeGlobalAgentsDir).filter(f => f.endsWith('.md'));

        let count = 0;
        agents.forEach(agent => {
            const agentPath = path.join(this.claudeGlobalAgentsDir, agent);
            fs.unlinkSync(agentPath);
            console.log(`  ✅ Removed: ${agent}`);
            count++;
        });

        if (count === 0) {
            console.log('  ℹ️  No claude-all agents to remove');
        } else {
            console.log(`📊 Removed ${count} global agents`);

            // Remove directory if empty
            if (fs.readdirSync(this.claudeGlobalAgentsDir).length === 0) {
                fs.rmdirSync(this.claudeGlobalAgentsDir);
                console.log(`  ✅ Removed empty directory: ${this.claudeGlobalAgentsDir}`);
            }
        }
    }

    removeGlobalHooks() {
        console.log('');
        console.log('🗑️  Removing global hooks...');

        if (!fs.existsSync(this.claudeHooksDir)) {
            console.log('  ⚠️  No hooks directory found');
            return;
        }

        // Remove claude-all specific hooks
        const hooks = ['hooks.json', 'run-hook.cmd', 'session-start.sh'];
        let count = 0;

        hooks.forEach(hook => {
            const hookPath = path.join(this.claudeHooksDir, hook);
            if (fs.existsSync(hookPath)) {
                fs.unlinkSync(hookPath);
                console.log(`  ✅ Removed: ${hook}`);
                count++;
            }
        });

        if (count === 0) {
            console.log('  ℹ️  No claude-all hooks to remove');
        } else {
            console.log(`📊 Removed ${count} global hooks`);
        }
    }

    removeSkills() {
        console.log('');
        console.log('🗑️  Removing global skills...');

        if (!fs.existsSync(this.claudeGlobalSkillsDir)) {
            console.log('  ⚠️  No global skills directory found');
            return;
        }

        // Remove all skills from global folder
        const skills = fs.readdirSync(this.claudeGlobalSkillsDir);
        let count = 0;

        skills.forEach(skill => {
            const skillPath = path.join(this.claudeGlobalSkillsDir, skill);
            const stat = fs.statSync(skillPath);

            if (stat.isDirectory()) {
                // Remove directory recursively
                const remove = (dir) => {
                    const items = fs.readdirSync(dir);
                    items.forEach(item => {
                        const fullPath = path.join(dir, item);
                        const itemStat = fs.statSync(fullPath);

                        if (itemStat.isDirectory()) {
                            remove(fullPath);
                            fs.rmdirSync(fullPath);
                        } else {
                            fs.unlinkSync(fullPath);
                        }
                    });
                };

                remove(skillPath);
                fs.rmdirSync(skillPath);
                console.log(`  ✅ Removed: ${skill}/`);
                count++;
            } else {
                fs.unlinkSync(skillPath);
                console.log(`  ✅ Removed: ${skill}`);
                count++;
            }
        });

        if (count === 0) {
            console.log('  ℹ️  No claude-all skills to remove');
        } else {
            console.log(`📊 Removed ${count} skills`);

            // Remove directory if empty
            try {
                if (fs.readdirSync(this.claudeGlobalSkillsDir).length === 0) {
                    fs.rmdirSync(this.claudeGlobalSkillsDir);
                    console.log(`  ✅ Removed empty directory: ${this.claudeGlobalSkillsDir}`);
                }
            } catch (e) {
                // Directory not empty or other error, ignore
            }
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

            // Remove commands
            this.removeCommands();

            // Remove global skills
            this.removeSkills();

            // Remove global agents
            this.removeAgents();

            // Remove global hooks
            this.removeGlobalHooks();

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
