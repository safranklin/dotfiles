# Code Quality

## Function Design

- Single responsibility per function. Refactor when they get too large.
- Maximum 3 parameters — use structs/objects for more.
- Descriptive names over comments. Comments explain "why", not "what".
- Pure functions when possible.

## Error Handling

- Explicit error handling at system boundaries. Never silently swallow errors.
- Fail fast with clear messages. Log errors with context.
- Use custom error types for domain logic.

## Principles

- **Simplicity first.** Simple solutions over clever ones, readability over brevity.
- **DRY after three.** Extract common logic when a pattern appears 3+ times. Not before.
- **Orthogonality.** Modules should be self-contained. Changes in one area shouldn't break others.
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
