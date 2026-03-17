---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/uv.lock"
---

# Python Development

## Tooling: uv

Use `uv` for everything Python. Never use `pip`, `pipenv`, or `poetry` directly.

| Task | Command |
|------|---------|
| New project | `uv init` |
| Add dependency | `uv add <package>` |
| Add dev dependency | `uv add --dev <package>` |
| Remove dependency | `uv remove <package>` |
| Install from lockfile | `uv sync` |
| Run a script | `uv run <script>` |
| Run a tool | `uvx <tool>` |
| Create venv | `uv venv` |
| Pin Python version | `uv python pin <version>` |

`pyproject.toml` is the single source of truth. `uv.lock` is committed.

## Project Layout

- Use `src/` layout: `src/<package_name>/`
- Pin Python version in `.python-version`
- Keep `pyproject.toml` as the sole config file — no `setup.py`, `setup.cfg`, or `requirements.txt`

## Type Hints

Type-hint everything that can be typed: function signatures, method signatures, class attributes, module-level variables. The only exceptions are where the type is genuinely uninferable or the annotation would be noisier than the code itself.

For structured data, match the tool to what's already in the project:
- **No external deps available** → `dataclasses`
- **Pydantic already present** → Pydantic models (validation + serialization come free)
- Don't add Pydantic just for data containers — `dataclasses` are fine for internal structs

## Modern Python

Use modern Python features where the project's minimum version supports them. Check `.python-version` or `pyproject.toml` `requires-python` before reaching for backports.

| Feature | Available since |
|---------|----------------|
| `match` / `case` statements | 3.10 |
| `X \| Y` union types in annotations | 3.10 |
| `tomllib` (stdlib TOML) | 3.11 |
| `Self` type | 3.11 |
| `type` aliases (`type Foo = ...`) | 3.12 |
| `@override` decorator | 3.12 |

Prefer:
- `Protocol` over ABC for structural subtyping — keeps coupling low
- `match` over long `if/elif` chains when switching on structure
- `pathlib.Path` over `os.path`
- `|` union syntax over `Optional[X]` / `Union[X, Y]` when the version supports it
