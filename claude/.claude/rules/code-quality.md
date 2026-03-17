# Code Quality

## Function Design

- Single responsibility per function. Refactor when they get too large.
- Maximum 3 parameters — use structs/objects for more.
- Descriptive names over comments. Comments explain "why", not "what".
- Pure functions when possible.
- **Tell, Don't Ask.** Tell objects to do things; don't reach through them to get state and make decisions on their behalf. If you're pulling data out of an object to decide what to do with it, that logic probably belongs on the object.

## Error Handling

- Explicit error handling at system boundaries. Never silently swallow errors.
- Fail fast with clear messages. Log errors with context.
- Use custom error types for domain logic.

## Principles

- **Simplicity first.** Simple solutions over clever ones, readability over brevity.
- **DRY — one authoritative source per piece of knowledge.** Not just duplicate code: duplicate documentation, config repeated across files, test data that mirrors a schema — all violate DRY. Every piece of knowledge must have a single, unambiguous, authoritative representation.
- **Orthogonality.** Modules should be self-contained. Changes in one area shouldn't break others.
- **No broken windows.** Don't leave known-bad code unaddressed. A broken window signals that quality doesn't matter, which accelerates rot. You don't have to fix it now — but file the issue, leave a comment, don't ignore it.
- **Reversibility.** Prefer designs where decisions can be changed. Avoid lock-in on unknowns. "There are no final decisions" — architect so you can adapt when requirements shift.
- **Defensive at boundaries.** Validate inputs at public interfaces. Trust internal code.
- **Make it work, make it right, make it fast** — in that order.
- **Comments are kindness.** Code should explain itself to future-you succinctly.
- **Dependencies are debt.** A single HTML file will work in 10 years. A React project from 2019? Good luck. Take on dependencies deliberately.

## Security

- Environment variables or secure vaults for sensitive data — never hardcode secrets.
- Sanitize user inputs. Parameterized queries for database operations.
- Never use `eval()` — use safe alternatives (`JSON.parse`, `ast.literal_eval`, etc.).
- Follow OWASP guidelines. Principle of least privilege.
- Don't expose system details in error messages.
