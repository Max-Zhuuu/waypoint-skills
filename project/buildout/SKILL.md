---
name: buildout
description: "Configure greenfield project scope with MoSCoW priorities and phase resolution. Extends /setup, run once at start."
status: deprecated
---

> **Deprecated.** Absorbed into `/setup`. Use `/setup` instead.

Extends /setup with greenfield-specific config. Run once at project start. After setup, use /check-in.

## Prerequisites

/setup must have run. Requires: SCOPE.md, ARCHITECTURE.md, CLAUDE.md with process definition.
Missing any -> tell user to run /setup first.

## Active workflow check

Read `## Active Workflow` in CLAUDE.md.
- Same skill active: redirect to /check-in or /reorient.
- Different skill active: warn replacement, ask whether to proceed.
- Completed: clear and proceed.

## Project intake

Read [reference/archetypes-and-ship-tiers.md](reference/archetypes-and-ship-tiers.md) first.

AskUserQuestion (multiSelect): "Which archetypes apply?" (Product / Feature / Deliverable / Design system).
Store as frontmatter in SCOPE.md: `archetypes: [product, design-system]`.

AskUserQuestion: "Ship standard?" (Hobby / Has real users (Recommended) / May grow).
Store as `ship-tier: hobby | users | growth` in SCOPE.md frontmatter.

## Workflow record

Read [reference/workflow-record-format.md](reference/workflow-record-format.md). Write `## Active Workflow` to CLAUDE.md. Update `Current phase` at each gate.

## Phase overview

| Phase | Name | File | Product | Feature | Deliverable |
|-------|------|------|---------|---------|-------------|
| 0-1 | Setup | /setup + this | full | full | full |
| 2 | Discovery | [02-discovery.md](phases/02-discovery.md) | full | reduced | skip |
| 3 | MVP build | [03-mvp-build.md](phases/03-mvp-build.md) | full | full | focused |
| 4 | Iterate & ship | [04-iterate-and-ship.md](phases/04-iterate-and-ship.md) | full | reduced | minimal |

Reduced = fewer checkpoints. Focused = Must only. Minimal = ship checklist only.

## Cross-references

Wrong skill? Recommend: existing codebase -> /create, replacing system -> /migrate, quick feature -> /spec + /tdd.

## Enforcement inputs

Read [reference/enforcement-rules.md](reference/enforcement-rules.md) for core + per-archetype rules before handing off to /check-in.

## Exit

- /check-in for daily sessions after setup.
- On exit, run the shared exit sequence: see [the exit sequence](../../internals/engagement/README.md#exit-sequence).
