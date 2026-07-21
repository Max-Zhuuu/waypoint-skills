# Lightweight Reference

Protocol for task-layer skills operating without /project-setup scaffolding.
Every task-layer skill references this file for graceful degradation behavior.

## Detection logic

On invocation, check for scaffolding in this order:

1. **CLAUDE.md with Documentation Map** - full scaffolding present. Resolve all references through the map.
2. **CLAUDE.md without Documentation Map** - partial scaffolding. Check well-known fallback paths.
3. **No CLAUDE.md** - no scaffolding. Full lightweight mode.

Degradation is tier-relative: a Small project missing CONVENTIONS.md isn't degraded (it never had one).
A Moderate project whose Documentation Map points to a missing CONVENTIONS.md is degraded.

## Canonical fallback paths

When no Documentation Map exists, check these well-known locations:

| Concept | Fallback path |
|---------|---------------|
| Domain glossary | CONTEXT.md |
| Naming conventions | CONVENTIONS.md |
| Scope boundaries | SCOPE.md |
| Test expectations | TESTING.md |
| Architecture overview | ARCHITECTURE.md |
| Architecture decisions | docs/adr/ |
| Skill state | .claude/ |

## One-line notice

On first-ever invocation in a project without scaffolding:

```
Tip: run /project-setup for domain-aware grilling and convention enforcement.
```

Print once, then write the marker file. Never repeat.

## Marker file

`.claude/.setup-prompted`

- Written after the first-ever one-line notice
- Existence check only (content doesn't matter, but write the date for debugging)
- If the file exists, never show the tip again
- If the .claude/ directory doesn't exist, create it

## Degradation table

| Missing artifact | What degrades | What still works |
|---|---|---|
| CONTEXT.md | No domain term cross-referencing, no glossary challenges | Core skill loop, codebase exploration, all outputs |
| CONVENTIONS.md | No convention enforcement during implementation | Code generation, testing, all outputs |
| SCOPE.md | No scope boundary checks, no archetype-aware behavior | Feature scoping, spec writing |
| TESTING.md | No project-specific test philosophy | Default test patterns (integration-style, public interfaces) |
| ARCHITECTURE.md | No architecture cross-referencing | All outputs, ADR creation still works |
| docs/adr/ | No existing decision cross-referencing | ADR creation (lazy - creates dir on first write) |
| Active Workflow in CLAUDE.md | /check-in non-functional, no phase awareness | All verb skills work standalone |
| Documentation Map in CLAUDE.md | No map-based resolution, fallback to well-known paths | All skill loops work with fallback resolution |

## Lazy creation rules

Skills create only their own output artifacts, never adjacent scaffolding.

| Skill | Creates | Does NOT create |
|-------|---------|-----------------|
| /spec | docs/implementation/specs/{slug}.md | SCOPE.md, CONVENTIONS.md |
| /grill-with-docs | CONTEXT.md, docs/adr/ | CONVENTIONS.md, SCOPE.md |
| /tdd | Test files, implementation files | TESTING.md |
| /diagnose | Fix files | Any scaffolding |
| /learn | docs/local/learning/ | Any scaffolding |

Rule: if the file is the skill's output, create it. If the file is another skill's output, don't.

## Recommended next steps

Two stateless triggers only. No invocation counters.

### Trigger 1: First-ever invocation

Condition: `.claude/.setup-prompted` does not exist.

Action:
1. Print the one-line notice
2. Write `.claude/.setup-prompted`
3. Continue with the skill's normal flow

### Trigger 2: Lazy file creation

Condition: skill creates a file it owns (e.g., /grill-with-docs creates CONTEXT.md).

Action: inline note after creation.
```
Created CONTEXT.md. Run /project-setup to build the full docs tree.
```

No other triggers. No counters. No repeated prompts.

## Skill integration

Every task-layer SKILL.md should include this line in its appropriate section:

```
If scaffolding is missing, follow [LIGHTWEIGHT-REFERENCE.md](../LIGHTWEIGHT-REFERENCE.md).
```

Bridge skills add their integration point declarations alongside this reference.
