# Migration-Specific Structure

Migration projects use `docs/program-legacy-{source}/` for the source system's reference material.
The `{source}` suffix identifies the source system (e.g., `wpf`, `rails`, `legacy-api`).
The Documentation Map aliases `docs/reference/` to this directory so skills resolve paths without knowing the source name.

```
docs/
  program/                         # Target system (what we're building)
    features/                      # Vue/React/etc. screen specs
  program-legacy-wpf/              # Source system (what we're replacing)
    features/                      # WPF screen specs
    logic/                         # Business rules from source
    inventory-plugins.md           # Plugin catalog with migration progress
```
