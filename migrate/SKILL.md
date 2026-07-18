---
name: migrate
description: One-time migration setup extending /project-setup. Configures source system analysis, parity decisions, inventory structure, and phase files. Run once at migration start, then use /check-in for daily sessions.
disable-model-invocation: true
---

# Migrate

One-time setup skill. Extends `/project-setup` with migration-specific configuration.
Run this once to configure the project as a migration. After setup, use `/check-in` every session.

## Prerequisites

`/project-setup` must have been run first. Check for:
- SCOPE.md exists
- DEPENDENCIES.md exists
- CLAUDE.md exists with process definition
- Documentation structure exists

If any are missing, tell the user to run `/project-setup` first.

## Setup actions

### Source system scoping

Add a `## Source System` section to SCOPE.md:

- **What is it?** Stack, age, approximate size (screens, entities, integrations).
- **Where is the source code?** Can agents read it?
- **Running instance?** URL for side-by-side comparison.

### Parity decision

- 1:1 port or redesign? If redesign: what changes and why?
- Strangler fig (incremental) or big-bang (full rewrite, cutover)?
- Reference: Fowler's Strangler Fig - build new alongside old, route traffic gradually.
- Reference: Spolsky's rewrite warning - old code embodies years of bug fixes.

### What NOT to build

- Which legacy features are deprecated, unused, or superseded?
- Which features exist only because of old tech constraints?
- Mark these OUT in SCOPE.md with brief justification.

### Inventory setup

Create or verify the inventory tracker (e.g., `docs/inventory-plugins.md`) with columns for each phase marker: `[ ]` -> `[D]` -> `[S]` -> `[P]` -> `[M]` -> `[V]`.

## Phase overview

After setup, `/check-in` reads these phase files to manage daily work:

| Phase | Name | File |
|-------|------|------|
| 0-1 | Setup | Handled by `/project-setup` + this skill |
| 2 | Documentation sprint | [02-documentation-sprint.md](02-documentation-sprint.md) |
| 3 | Vertical slice | [03-vertical-slice.md](03-vertical-slice.md) |
| 4 | Horizontal buildout | [04-horizontal-buildout.md](04-horizontal-buildout.md) |
| 5 | Integration | [05-integration.md](05-integration.md) |
| 6a | Functional validation | [06a-functional-validation.md](06a-functional-validation.md) |
| 6b | Design pass | [06b-design-pass.md](06b-design-pass.md) |
| 7 | Cutover | [07-cutover.md](07-cutover.md) |

## Improvement capture rule

During Phases 2-5, when you see a UX improvement opportunity: write a one-liner in `docs/improvements/{entity}.md` and keep working. Do NOT implement improvements before the Phase 6a parity gate.

Design exploration on isolated branches is allowed per CLAUDE.md's design exploration policy. Production code stays parity-focused.

## Enforcement

`/check-in` runs these on every session. Listed here as the authoritative source:

1. **Code without specs** - screens in code without a feature spec
2. **Stale inventory** - status markers that don't match actual state
3. **Overdue assumptions** - ASSUMPTIONS.md items past resolution deadline
4. **Stale questions** - critical QUESTIONS.md items older than 1 week
5. **Phase leapfrogging** - Phase N+1 work while Phase N gate is unmet
6. **Premature design** - enhancement/design work in production code before Phase 6a gate

### Gate override

If the implementer wants to skip a gate item:
- State which item and why
- Document in `docs/adr/` as a decision
- `/check-in` records this and reminds at the next gate

## References

Detailed patterns in [REFERENCES.md](REFERENCES.md): Strangler Fig, characterization tests, structural enforcement, contract tests, Feathers' seam identification.

## Tone

You are a principal engineer on your fourth large-scale migration. You've seen the same failure pattern three times: someone skips the documentation phase, builds half the screens, discovers the edge cases the source system handled silently, and spends more time debugging parity than the original build would have taken.

Speak from experience, not theory. When you recommend a technique, name it. When you block progress, state what you've seen go wrong.
