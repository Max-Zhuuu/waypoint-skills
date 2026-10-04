# Documentation Map Reference

Read by /setup when generating the project documentation structure.

## Single-file structure

After consolidation, all project documentation lives in CLAUDE.md sections.
The only files outside CLAUDE.md are:

```
CLAUDE.md                          # The single agent-readable project document
docs/
  _GLOSSARY.md                     # Domain glossary (shared reference, tiny)
  decisions/                       # Full ADRs (complex, hard-to-reverse decisions)
  _local/                          # Gitignored working state
    learnings/
    notes/
architecture-rule-catalogue.md    # Enforcement rule index (if project has one)
test-registry.json                # Machine-enforceable test registry (if project has one)
contracts/                        # Machine-generated contracts (if applicable)
  openapi.json
  *-endpoints.json
```

## What lives where

| Content | Location | Rationale |
|---------|----------|-----------|
| Scope, conventions, architecture, deployment, product context | CLAUDE.md sections | Auto-loaded, zero read cost |
| Simple design decisions | ### Key design decisions in CLAUDE.md | One bullet per decision, no ADR ceremony |
| Complex design decisions | docs/decisions/NNNN-*.md | Full ADR with rationale, trade-offs, revisit triggers |
| Domain terminology | docs/_GLOSSARY.md | Shared across repos, tiny, separate concern |
| Enforcement rules | architecture-rule-catalogue.md | Guarded by tests, own lifecycle |
| Test registry | test-registry.json | Machine-enforced, own lifecycle |
| API contracts | contracts/ | Machine-generated, consumed by multiple systems |
| Invariants, constraints, business rules | Inline code comments | At the line they govern, not in external docs |
| Work items, priorities, future state | Linear (MAP-* issues) | Never duplicated in docs |

## Naming convention

Ask via `AskUserQuestion` before generating the doc structure:

**How should docs/ folders sort in your file explorer?**
- **Underscore-prefixed (recommended)**: `_GLOSSARY.md` and `_local/` sort to the top
- **Clean names**: `GLOSSARY.md` and `local/` - natural names

Default to underscore-prefixed.

## Migration projects

Add `docs/program-legacy-{source}/` with features/ and logic/ subdirectories.

## ## References section in CLAUDE.md

After generating the docs/ tree, write the ## References section in CLAUDE.md:

```markdown
## References

- `docs/decisions/` - Architecture decision records
- `docs/_GLOSSARY.md` - Domain terminology
- `architecture-rule-catalogue.md` - Enforcement rule index
- `test-registry.json` - Machine-enforceable test registry
- `contracts/openapi.json` - Generated API spec
```

Only include entries that exist in the project.
On re-entry, read the existing ## References and only update entries that changed.
