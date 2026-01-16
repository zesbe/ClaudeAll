#!/usr/bin/env node

/**
 * 🦸 Claude-All Superpowers Installer
 * Menginstall skills, commands, agents, dan hooks ke Claude Code
 */

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

class SuperpowersInstaller {
    constructor() {
        this.homeDir = os.homedir();
        this.packageDir = path.resolve(__dirname, '..');
        this.superpowersDir = path.join(this.packageDir, 'superpowers');
        this.claudeDir = path.join(this.homeDir, '.claude');

        // Claude Code paths
        this.claudePluginsDir = path.join(this.claudeDir, 'plugins', 'claude-all-superpowers');
        this.claudeCommandsDir = path.join(this.claudeDir, 'commands');
        this.claudeSkillsDir = path.join(this.claudePluginsDir, 'skills');
        this.claudeAgentsDir = path.join(this.claudePluginsDir, 'agents');
        this.claudeGlobalAgentsDir = path.join(this.claudeDir, 'agents'); // Global agents folder
        this.claudeHooksDir = path.join(this.claudePluginsDir, 'hooks');
        this.claudeLibDir = path.join(this.claudePluginsDir, 'lib');
        this.claudeTestsDir = path.join(this.claudePluginsDir, 'tests');
    }

    printHeader() {
        console.log('');
        console.log('🦸 CLAUDE-ALL SUPERPOWERS INSTALLER');
        console.log('===================================');
        console.log('');
        console.log('Installing superpowers to Claude Code:');
        console.log('  ✅ Skills (specialized capabilities)');
        console.log('  ✅ Commands (slash commands)');
        console.log('  ✅ Agents (task automation)');
        console.log('  ✅ Hooks (git hooks)');
        console.log('  ✅ Libraries (helper functions)');
        console.log('  ✅ Tests (test suites)');
        console.log('');
    }

    checkPrerequisites() {
        console.log('🔍 Checking prerequisites...');

        // Check if Claude directory exists
        if (!fs.existsSync(this.claudeDir)) {
            console.log(`⚠️  Claude directory not found: ${this.claudeDir}`);
            console.log('💡 Make sure Claude Code CLI is installed first');
            return false;
        }

        // Check if superpowers directory exists
        if (!fs.existsSync(this.superpowersDir)) {
            console.log(`❌ Superpowers directory not found: ${this.superpowersDir}`);
            return false;
        }

        console.log(`✅ Claude directory: ${this.claudeDir}`);
        console.log(`✅ Superpowers source: ${this.superpowersDir}`);
        return true;
    }

    createDirectories() {
        console.log('');
        console.log('📁 Creating directories...');

        const dirs = [
            this.claudePluginsDir,
            this.claudeSkillsDir,
            this.claudeAgentsDir,
            this.claudeHooksDir,
            this.claudeLibDir,
            this.claudeCommandsDir
        ];

        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
                console.log(`  ✅ Created: ${path.basename(dir)}`);
            } else {
                console.log(`  ✓ Exists: ${path.basename(dir)}`);
            }
        });
    }

    copyDirectory(src, dest, name) {
        if (!fs.existsSync(src)) {
            console.log(`  ⚠️  Skipped ${name}: source not found`);
            return 0;
        }

        let count = 0;

        const copy = (source, destination) => {
            const stat = fs.statSync(source);

            if (stat.isDirectory()) {
                const items = fs.readdirSync(source);
                items.forEach(item => {
                    copy(path.join(source, item), path.join(destination, item));
                });
            } else {
                // Create destination directory if needed
                const destDir = path.dirname(destination);
                if (!fs.existsSync(destDir)) {
                    fs.mkdirSync(destDir, { recursive: true });
                }

                fs.copyFileSync(source, destination);
                count++;
            }
        };

        copy(src, dest);
        return count;
    }

    installSkills() {
        console.log('');
        console.log('🎯 Installing Skills...');

        const skillsSource = path.join(this.superpowersDir, 'skills');
        const skillsDest = this.claudeSkillsDir;

        if (!fs.existsSync(skillsSource)) {
            console.log('  ⚠️  No skills directory found');
            return;
        }

        const skills = fs.readdirSync(skillsSource);
        let count = 0;

        skills.forEach(skill => {
            const srcPath = path.join(skillsSource, skill);
            const destPath = path.join(skillsDest, skill);

            const numFiles = this.copyDirectory(srcPath, destPath, skill);
            if (numFiles > 0) {
                console.log(`  ✅ ${skill} (${numFiles} files)`);
                count++;
            }
        });

        console.log(`📊 Total: ${count} skills installed`);
    }

    installCommands() {
        console.log('');
        console.log('⚡ Installing Commands...');

        const commandsSource = path.join(this.superpowersDir, 'commands');
        const commandsDest = this.claudeCommandsDir;

        if (!fs.existsSync(commandsSource)) {
            console.log('  ⚠️  No commands directory found');
            return;
        }

        const commands = fs.readdirSync(commandsSource).filter(f => f.endsWith('.md'));
        let count = 0;

        commands.forEach(cmd => {
            const srcPath = path.join(commandsSource, cmd);
            const destPath = path.join(commandsDest, cmd);

            fs.copyFileSync(srcPath, destPath);
            console.log(`  ✅ /${cmd.replace('.md', '')}`);
            count++;
        });

        console.log(`📊 Total: ${count} commands installed`);
    }

    installAgents() {
        console.log('');
        console.log('🤖 Installing Agents...');

        const agentsSource = path.join(this.superpowersDir, 'agents');
        const agentsPluginDir = this.claudeAgentsDir;
        const agentsGlobalDir = this.claudeGlobalAgentsDir;

        if (!fs.existsSync(agentsSource)) {
            console.log('  ⚠️  No agents directory found');
            return;
        }

        // Ensure global agents directory exists
        if (!fs.existsSync(agentsGlobalDir)) {
            fs.mkdirSync(agentsGlobalDir, { recursive: true });
        }

        const agents = fs.readdirSync(agentsSource);
        let count = 0;

        agents.forEach(agent => {
            const srcPath = path.join(agentsSource, agent);

            // Copy to plugin agents directory
            const destPath1 = path.join(agentsPluginDir, agent);
            fs.copyFileSync(srcPath, destPath1);

            // Also copy to global Claude agents directory (so they're available globally)
            const destPath2 = path.join(agentsGlobalDir, agent);
            fs.copyFileSync(srcPath, destPath2);

            console.log(`  ✅ ${agent} → plugin & global`);
            count++;
        });

        console.log(`📊 Total: ${count} agents installed (to both locations)`);
    }

    installHooks() {
        console.log('');
        console.log('🪝 Installing Hooks...');

        const hooksSource = path.join(this.superpowersDir, 'hooks');
        const hooksDest = this.claudeHooksDir;
        const claudeMainHooksDir = path.join(this.claudeDir, 'hooks');

        if (!fs.existsSync(hooksSource)) {
            console.log('  ⚠️  No hooks directory found');
            return;
        }

        // Ensure main hooks directory exists
        if (!fs.existsSync(claudeMainHooksDir)) {
            fs.mkdirSync(claudeMainHooksDir, { recursive: true });
        }

        const hooks = fs.readdirSync(hooksSource);
        let count = 0;

        hooks.forEach(hook => {
            const srcPath = path.join(hooksSource, hook);

            // Copy to plugin hooks directory
            const destPath1 = path.join(hooksDest, hook);
            const numFiles1 = this.copyDirectory(srcPath, destPath1, hook);

            // Also copy to main Claude hooks directory (so they can be executed)
            const destPath2 = path.join(claudeMainHooksDir, hook);
            const numFiles2 = this.copyDirectory(srcPath, destPath2, hook);

            if (numFiles1 > 0) {
                console.log(`  ✅ ${hook} (${numFiles1} files) → plugins & main hooks`);
                count++;
            }
        });

        console.log(`📊 Total: ${count} hooks installed (to both locations)`);
    }

    installLibs() {
        console.log('');
        console.log('📚 Installing Libraries...');

        const libsSource = path.join(this.superpowersDir, 'lib');
        const libsDest = this.claudeLibDir;

        if (!fs.existsSync(libsSource)) {
            console.log('  ⚠️  No lib directory found');
            return;
        }

        const libs = fs.readdirSync(libsSource);
        let count = 0;

        libs.forEach(lib => {
            const srcPath = path.join(libsSource, lib);
            const destPath = path.join(libsDest, lib);

            fs.copyFileSync(srcPath, destPath);
            console.log(`  ✅ ${lib}`);
            count++;
        });

        console.log(`📊 Total: ${count} libraries installed`);
    }

    installTests() {
        console.log('');
        console.log('🧪 Installing Tests...');

        const testsSource = path.join(this.superpowersDir, 'tests');
        const testsDest = this.claudeTestsDir;

        if (!fs.existsSync(testsSource)) {
            console.log('  ⚠️  No tests directory found');
            return;
        }

        const testSuites = fs.readdirSync(testsSource);
        let count = 0;

        testSuites.forEach(suite => {
            const srcPath = path.join(testsSource, suite);
            const destPath = path.join(testsDest, suite);

            const numFiles = this.copyDirectory(srcPath, destPath, suite);
            if (numFiles > 0) {
                console.log(`  ✅ ${suite} (${numFiles} files)`);
                count++;
            }
        });

        console.log(`📊 Total: ${count} test suites installed`);
    }

    createManifest() {
        console.log('');
        console.log('📋 Creating manifest...');

        const manifest = {
            name: 'claude-all-superpowers',
            version: fs.readFileSync(path.join(this.packageDir, 'VERSION'), 'utf8').trim(),
            description: 'Claude-All Superpowers Collection',
            installedAt: new Date().toISOString(),
            components: {
                skills: fs.existsSync(this.claudeSkillsDir) ? fs.readdirSync(this.claudeSkillsDir).length : 0,
                commands: fs.existsSync(this.claudeCommandsDir) ? fs.readdirSync(this.claudeCommandsDir).filter(f => f.endsWith('.md')).length : 0,
                agents: fs.existsSync(this.claudeAgentsDir) ? fs.readdirSync(this.claudeAgentsDir).length : 0,
                hooks: fs.existsSync(this.claudeHooksDir) ? fs.readdirSync(this.claudeHooksDir).length : 0,
                libs: fs.existsSync(this.claudeLibDir) ? fs.readdirSync(this.claudeLibDir).length : 0,
                tests: fs.existsSync(this.claudeTestsDir) ? fs.readdirSync(this.claudeTestsDir).length : 0
            }
        };

        const manifestPath = path.join(this.claudePluginsDir, 'manifest.json');
        fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
        console.log(`  ✅ Manifest created: ${manifestPath}`);
    }

    showCompletion() {
        console.log('');
        console.log('🎉 SUPERPOWERS INSTALLATION COMPLETED!');
        console.log('=====================================');
        console.log('');
        console.log('✅ All superpowers installed to Claude Code');
        console.log('');
        console.log('📍 Installation Location:');
        console.log(`   ${this.claudePluginsDir}`);
        console.log('');
        console.log('🚀 Usage:');
        console.log('   Restart Claude Code CLI to load superpowers');
        console.log('');
        console.log('📚 Available Superpowers:');
        console.log('   • Skills - Specialized capabilities');
        console.log('   • Commands - Slash commands');
        console.log('   • Agents - Task automation');
        console.log('   • Hooks - Git hooks');
        console.log('   • Libraries - Helper functions');
        console.log('   • Tests - Test suites');
        console.log('');
        console.log('💡 Tip: Use /help in Claude Code to see available commands');
        console.log('');
    }

    async install() {
        try {
            this.printHeader();

            if (!this.checkPrerequisites()) {
                console.log('');
                console.log('❌ Installation failed: Prerequisites not met');
                process.exit(1);
            }

            this.createDirectories();
            this.installSkills();
            this.installCommands();
            this.installAgents();
            this.installHooks();
            this.installLibs();
            this.installTests();
            this.createManifest();
            this.showCompletion();

        } catch (error) {
            console.error('');
            console.error('❌ Installation failed:', error.message);
            console.error(error.stack);
            process.exit(1);
        }
    }
}

// Run installer if called directly
if (require.main === module) {
    const installer = new SuperpowersInstaller();
    installer.install();
}

module.exports = SuperpowersInstaller;
