// Custom Claude Library Functions
// Save to ~/.claude/lib/custom-utils.js

// Utility functions for Claude to use
module.exports = {
  // File operations
  async countLines(filePath) {
    const fs = require('fs').promises;
    try {
      const content = await fs.readFile(filePath, 'utf8');
      return content.split('\n').length;
    } catch (error) {
      return 0;
    }
  },

  // Project analysis
  async analyzeProject(directory) {
    const fs = require('fs').promises;
    const path = require('path');

    const stats = {
      files: 0,
      directories: 0,
      extensions: {},
      totalLines: 0
    };

    async function walk(dir) {
      const items = await fs.readdir(dir);
      for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = await fs.stat(fullPath);

        if (stat.isDirectory()) {
          stats.directories++;
          await walk(fullPath);
        } else {
          stats.files++;
          const ext = path.extname(item).toLowerCase();
          stats.extensions[ext] = (stats.extensions[ext] || 0) + 1;

          // Count lines for text files
          const textExtensions = ['.js', '.ts', '.py', '.java', '.cpp', '.c', '.md', '.txt', '.json', '.yaml', '.yml'];
          if (textExtensions.includes(ext)) {
            stats.totalLines += await this.countLines(fullPath);
          }
        }
      }
    }

    await walk(directory);
    return stats;
  },

  // Generate project summary
  generateProjectSummary(stats) {
    const sortedExts = Object.entries(stats.extensions)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([ext, count]) => `${ext} (${count})`)
      .join(', ');

    return `
Project Analysis:
- Files: ${stats.files}
- Directories: ${stats.directories}
- Total Lines: ${stats.totalLines}
- Top Extensions: ${sortedExts}
    `.trim();
  },

  // Template generators
  generateReadme(projectName, type = 'general') {
    const templates = {
      api: `# ${projectName} API

## Installation
\`\`\`bash
npm install
\`\`\`

## Usage
\`\`\`javascript
const API = require('${projectName}');
const api = new API();
\`\`\`

## Endpoints
- GET /api/items
- POST /api/items
- PUT /api/items/:id
- DELETE /api/items/:id
`,

      cli: `# ${projectName} CLI Tool

## Installation
\`\`\`bash
npm install -g ${projectName}
\`\`\`

## Usage
\`\`\`bash
${projectName} --help
${projectName} --version
\`\`\`
`,

      general: `# ${projectName}

## Description
TODO: Add project description

## Installation
\`\`\`bash
npm install
\`\`\`

## Usage
TODO: Add usage instructions
`
    };

    return templates[type] || templates.general;
  },

  // Git helpers
  async getGitStats() {
    const { exec } = require('child_process');
    const { promisify } = require('util');
    const execAsync = promisify(exec);

    try {
      const [hash, branch, commits] = await Promise.all([
        execAsync('git rev-parse HEAD').then(r => r.stdout.trim()),
        execAsync('git rev-parse --abbrev-ref HEAD').then(r => r.stdout.trim()),
        execAsync('git rev-list --count HEAD').then(r => parseInt(r.stdout.trim()))
      ]);

      return { hash: hash.substring(0, 7), branch, commits };
    } catch {
      return null;
    }
  },

  // Environment helpers
  detectEnvironment() {
    const env = {
      node: typeof process !== 'undefined',
      browser: typeof window !== 'undefined',
      deno: typeof Deno !== 'undefined'
    };

    if (env.node) {
      env.packageManager = fs.existsSync('yarn.lock') ? 'yarn' :
                          fs.existsSync('pnpm-lock.yaml') ? 'pnpm' : 'npm';
    }

    return env;
  },

  // Code quality checks
  async checkCodeQuality(directory) {
    const fs = require('fs').promises;
    const issues = [];

    async function checkFile(filePath) {
      const content = await fs.readFile(filePath, 'utf8');

      // Check for console.log statements
      if (content.includes('console.log')) {
        issues.push(`${filePath}: Contains console.log statements`);
      }

      // Check for TODO comments
      if (content.includes('TODO:') || content.includes('FIXME:')) {
        issues.push(`${filePath}: Contains TODO/FIXME comments`);
      }

      // Check for long lines (> 120 characters)
      const lines = content.split('\n');
      lines.forEach((line, i) => {
        if (line.length > 120) {
          issues.push(`${filePath}:${i + 1}: Line too long (${line.length} chars)`);
        }
      });
    }

    // Scan JavaScript/TypeScript files
    const jsFiles = await this.findFiles(directory, ['.js', '.ts']);
    await Promise.all(jsFiles.map(checkFile));

    return issues;
  },

  // File system helpers
  async findFiles(directory, extensions) {
    const fs = require('fs').promises;
    const path = require('path');
    const results = [];

    async function walk(dir) {
      const items = await fs.readdir(dir);
      for (const item of items) {
        if (item.startsWith('.')) continue;

        const fullPath = path.join(dir, item);
        const stat = await fs.stat(fullPath);

        if (stat.isDirectory()) {
          await walk(fullPath);
        } else if (extensions.includes(path.extname(item))) {
          results.push(fullPath);
        }
      }
    }

    await walk(directory);
    return results;
  }
};