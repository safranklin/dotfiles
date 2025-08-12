# AGENT.md Configuration Management

This repository uses the [AGENT.md specification](https://ampcode.com/AGENT.md) for universal agent configuration. Rather than maintaining separate configuration files for different AI coding tools (`.cursorrules`, `.clauderules`, `.windsurfrules`, etc.), we use a single `AGENT.md` file that serves as the source of truth for all agentic tools.

## Setup

The configuration is managed through relative symbolic linking to maintain version control while satisfying tool-specific expectations:

```bash
# Create the relative symbolic link from Claude's expected location to our versioned file
cd ~/.claude
ln -sf ../agent/AGENT.md CLAUDE.md
```

This creates the following structure:

```
~/.agent/AGENT.md          # Primary configuration (version controlled)
~/.claude/CLAUDE.md        # Symbolic link -> ../.agent/AGENT.md
```

Using relative paths makes the symlinks portable across different machines and dotfiles locations.

## What is AGENT.md?

The AGENT.md specification defines a standardized format that lets your codebase speak directly to any agentic coding tool. Instead of fragmenting configuration across multiple tool-specific files, this approach provides a single, human-readable configuration file that works across the growing ecosystem of AI coding tools.

The file should contain guidance on:

- Project structure and organization
- Build, test, and development commands  
- Code style and conventions
- Architecture and design patterns
- Testing guidelines
- Security considerations

## Benefits

**Single Source of Truth**: One configuration file replaces the scattered mess of `.cursorrules`, `.clauderules`, `.windsurfrules`, and other tool-specific files.

**Version Control**: Keep your agent configuration alongside other dotfiles, tracking changes and maintaining consistency across environments.

**Tool Compatibility**: Works with existing tools through symbolic linking while preparing for native AGENT.md support across the ecosystem.

**Human Readable**: Markdown format makes the configuration accessible to both humans and AI tools, serving as documentation and instruction simultaneously.

## Supported Tools

The specification already works with multiple tools through symbolic linking:

- **Claude Code**: Native support via `~/.claude/CLAUDE.md`
- **Cursor**: Via symbolic link to `.cursorrules`
- **Windsurf**: Via symbolic link to `.windsurfrules`  
- **Cline**: Via symbolic link to `.clinerules`
- **GitHub Copilot**: Via symbolic link to `.github/copilot-instructions.md`

Additional tools are adopting native AGENT.md support, making symbolic links unnecessary over time.

## Migration from Legacy Files

If you have existing tool-specific configuration files, you can consolidate them:

```bash
# Move existing Claude configuration and create relative symbolic link
mv ~/.claude/CLAUDE.md ~/.agent/AGENT.md
cd ~/.claude
ln -sf ../.agent/AGENT.md CLAUDE.md
```

This preserves your existing configuration while establishing the new structure for version control and universal compatibility.