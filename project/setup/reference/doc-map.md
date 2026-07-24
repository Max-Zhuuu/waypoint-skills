# Documentation Map Reference

Read by /setup when generating or updating the Documentation Map in CLAUDE.md.

## Naming convention

Ask via `AskUserQuestion` before generating the doc structure:

**How should docs/ folders sort in your file explorer?**
- **Underscore-prefixed (recommended)**: `_GLOSSARY.md` and `_local/` sort to the top in most file explorers and GitHub web UI. Other tiers keep clean names.
- **Clean names**: `GLOSSARY.md` and `local/` - natural names, rely on alphabetical ordering (i < l < p already sorts correctly for tiers).

Default to underscore-prefixed. Apply the chosen convention to all generated paths and the Documentation Map.

## Root-level enforcement

Only these entries belong at `docs/` root:
- `_GLOSSARY.md` (or `GLOSSARY.md` with clean convention)
- Tier folders: `program/`, `implementation/`, `_local/` (or `local/`)
- Migration-specific: `program-legacy-{source}/`

Everything else goes inside a tier. When restructuring or on re-entry, flag stray files at `docs/` root:
```
Found docs/foo.md outside any tier.
  -> program/ (describes what the system IS)
  -> implementation/ (describes what we're DOING)
  -> delete (redundant with Documentation Map or another doc)
Which tier?
```

## Default map (underscore convention)

```markdown
## Documentation Map

docs/
  **_GLOSSARY.md**               # Domain glossary - canonical terms, avoid-lists
  program/                       # What the system IS
    **ARCHITECTURE.md**          # Stack, state management, data flow, deps
    **TESTING.md**               # Test expectations by complexity tier
    conventions/
      **NAMING.md**              # Variables, functions, components
      UX.md                      # Interaction patterns, confirmations
    adr/                         # Architecture decision records
  implementation/                # What we're DOING
    **SCOPE.md**                 # In/out/uncertain
    **CONCERNS.md**              # Questions, assumptions, issues, milestones
    specs/                       # Feature specs (flat, active)
  _local/                        # Gitignored working state
```

Tier-dependent: small projects may flatten (SCOPE.md at root, no program/ directory).
Large projects add: program/STRUCTURE.md, program/DESIGN.md, program/features/, program-legacy-{source}/, implementation/handoffs/, implementation/improvements/.

On re-entry, read the existing map and only update entries that changed. Don't regenerate from scratch.
As scope scales, nudge the user to add entries for new doc areas (e.g., "You have 5 specs now - worth adding a specs/ entry to the map?").
