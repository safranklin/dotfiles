# Testing

Test your software, or your users will.

## Principles

- **Test early, test often, test automatically.** Tests that aren't run automatically aren't tests — they're hopes.
- **Hard to test = bad design.** If writing a test for something feels painful, the design is probably wrong. Testability is a design signal, not an afterthought.
- **Tests are the first users of your code.** Write them that way — if the API is awkward to test, it's awkward to use.
- **Test behavior, not implementation.** Tests that mirror internal structure break on refactoring. Test what the code does, not how.
- **One assertion per concept.** Tests that fail for multiple reasons are hard to diagnose. Keep tests focused.

## What to Test

- **Happy path** — does it do what it's supposed to?
- **Boundaries** — off-by-ones, empty inputs, max values.
- **Error paths** — does it fail correctly when things go wrong?
- **Contracts** — if a function promises something, test that promise holds.

## Practical

- Tests live next to the code they test (or in a parallel `tests/` tree — be consistent within a project).
- A test that's slow enough to skip is a test that won't be run. Keep unit tests fast.
- Integration tests are valuable but expensive — use them at seams, not everywhere.
- Delete tests that no longer reflect reality rather than commenting them out.
