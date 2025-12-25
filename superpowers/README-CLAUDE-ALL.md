# Superpowers - Included in Claude-All-New

This is the complete Superpowers library bundled with Claude-All-New.

## What's Included:

### 📁 Directory Structure
- `agents/` - Specialized agents (code reviewer)
- `commands/` - Core commands (brainstorm, write-plan, execute-plan)
- `hooks/` - Workflow automation hooks
- `lib/` - Core library (skills-core.js)
- `skills/` - 20+ development skills
- `docs/` - Documentation for different platforms
- `tests/` - Test files

### 🎯 Skills Available:
1. **brainstorming** - Design refinement through questioning
2. **writing-plans** - Create implementation plans
3. **test-driven-development** - RED-GREEN-REFACTOR cycle
4. **subagent-driven-development** - Execute with fresh agents
5. **requesting-code-review** - Systematic code review
6. **receiving-code-review** - Handle review feedback
7. **systematic-debugging** - Root cause analysis
8. **root-cause-tracing** - Trace issues to source
9. **verification-before-completion** - Quality checks
10. **finishing-a-development-branch** - Complete workflow
11. **using-git-worktrees** - Parallel development
12. **condition-based-waiting** - Wait for conditions
13. **defense-in-depth** - Multi-layer validation
14. **dispatching-parallel-agents** - Parallel execution
15. **testing-anti-patterns** - Avoid testing mistakes
16. **testing-skills-with-subagents** - Test automation
17. **using-superpowers** - Meta-skills
18. **writing-skills** - Create custom skills
19. **sharing-skills** - Distribute skills

## Installation:

This is automatically installed by Claude-All-New installer to:
```bash
~/.claude/plugins/superpowers/
```

## Usage in Claude:

```bash
claude

# Available commands:
/superpowers:brainstorm    # Refine ideas
/superpowers:write-plan    # Create plan
/superpowers:execute-plan  # Execute step-by-step
```

## Version:
Based on superpowers v3.6.2
https://github.com/obra/superpowers