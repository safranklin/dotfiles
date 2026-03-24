---
name: retrospective
description: Use when repeated corrections, repeated manual steps, or recurring friction appear in a session — or when the user asks to review the session for improvement opportunities
---

# Retrospective

Review a session for patterns that should be encoded in steering artifacts so they don't recur.

## Core Principle

If you notice a pattern, fix the harness — not yourself. "I'll do better next time" is not a fix. Steering changes (CLAUDE.md, hooks, skills, settings) persist across sessions; your good intentions don't.

## When to Trigger

**Proactively** — when you notice any of these mid-session:
- User corrects the same behavior twice
- You run the same manual sequence repeatedly
- You hit the same friction point (permission prompt, wrong command, wrong directory) more than once
- You work around something that could be automated

When you notice: pause and ask — "This keeps coming up. Want to do a quick retrospective on this pattern?"

**Manually** — user runs `/retrospective` or asks to review the session.

## The Review

For each pattern identified:

1. **Name the pattern.** What keeps happening? Be specific.
2. **Identify the root cause.** Why does it recur? Missing instruction? Missing automation? Ambiguous guidance?
3. **Classify the fix** using the decision table below.
4. **Draft the specific change.** Show the actual text, config, or code — not a vague suggestion.
5. **Propose, don't apply.** Present the change and wait for approval.

## Fix Decision Table

| Pattern | Fix | Where |
|---------|-----|-------|
| Behavioral correction ("don't do X", "always do Y") | Rule or constraint | CLAUDE.md / rules/ |
| Repeated manual action after file edits (format, lint, validate) | PostToolUse hook | settings.json / settings.local.json |
| Repeated manual action before tool use (validation, checks) | PreToolUse hook | settings.json / settings.local.json |
| Tool permission prompts for safe, frequent commands | Permission allow rule | settings.json |
| Reusable technique applicable across projects | Skill | ~/.claude/skills/ |
| Project-specific convention or constraint | Project instruction | project CLAUDE.md or .claude/rules/ |
| Recurring context about the user or their preferences | Feedback or user memory | memory/ |
| "I should just be better about this" | **Stop.** This is not a fix. Walk the table again. | — |

## Anti-Patterns

- **Vague proposals.** "We should update CLAUDE.md" — with what? Show the exact addition.
- **Self-blame as solution.** "I'll remember next time" — you won't. You're stateless across sessions.
- **Over-engineering.** Not every correction needs a hook. One-off mistakes are fine. The threshold is *recurrence*.
- **Mixing levels.** A hook that auto-formats is better than a CLAUDE.md rule that says "remember to format." Prefer automation over instruction when possible.

## Output Format

For each proposed change:

```
### Pattern: [name]
**Observed:** [what happened, how many times]
**Root cause:** [why it recurs]
**Fix type:** [from decision table]
**Target:** [exact file path]
**Change:**
[the actual diff, config block, or text to add]
```
