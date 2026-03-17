# Git Practices

## Core Principles

- **Commit prolifically with good messages.** Small, frequent commits. Each one should be a self-contained, reviewable unit of work.
- **Conventional commits, always.** `type(scope): description` — type and scope give structure; description gives intent.
- **The diff is the "what", the message is the "why".** An LLM (or human) reading `git log` and `git diff` should reconstruct full context without separate planning artifacts.
- **Never add a `Co-Authored-By` line.** All commits authored solely by the human.
- **Work on main.** For low-contributor projects, commit directly to main. Reserve branches for exploratory or risky work where you might discard an entire sequence of commits.
- **PRs are the detailed record.** For team projects, PRs capture the commit-by-commit reasoning. Reference PRs in commit messages (`closes #N`).
- **`*.local.md` for ephemeral context.** Gitignore `*.local.md` in repo roots for session scratch notes that don't belong in history.

## Why Git Hygiene Compounds

Consistent git history reduces context reconstruction for everyone — future-you, new teammates, AI agents picking up a project. A model reading a PR sees the commit-by-commit reasoning chain, answering "why did this end up this way" without separate documentation. Light code comments + detailed commit messages + detailed PRs compounds as repos grow.
