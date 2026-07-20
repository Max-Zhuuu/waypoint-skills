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

Two sequential AskUserQuestion gates:

**Q1: "What's the migration strategy?"**
- **1:1 parity port (Recommended)** - replicate source behavior exactly, improve later in Phase 6b
- **Selective redesign** - port core, redesign specific areas (user lists which areas and why)
- **Full redesign** - new UX informed by old, not constrained by it

**Q2: "What's the cutover approach?"**
- **Strangler fig (Recommended)** - incremental, run both systems, shift traffic gradually
- **Big-bang** - build everything, cut over at once
- **Parallel run** - both systems live, compare output, switch when confident

If the combination creates tension (e.g., full redesign + strangler fig), note it conversationally after both answers - don't filter options.

Store both answers in SCOPE.md `## Source System` section.

Reference: Fowler's Strangler Fig - build new alongside old, route traffic gradually.
Reference: Spolsky's rewrite warning - old code embodies years of bug fixes.

### What NOT to build

- Which legacy features are deprecated, unused, or superseded?
- Which features exist only because of old tech constraints?
- Mark these OUT in SCOPE.md with brief justification.

### Inventory setup

Create or verify the inventory tracker (e.g., `docs/inventory-plugins.md`) with columns for each phase marker: `[ ]` -> `[D]` -> `[S]` -> `[P]` -> `[M]` -> `[V]`.

## Phase overview

### Workflow record

Write the `## Active Workflow` section to CLAUDE.md:

```markdown
## Active Workflow

| Field | Value |
|-------|-------|
| Skill | /migrate |
| Activated | {date} |
| Source system | {name from source system scoping} |
| Current phase | Phase 2 - Documentation Sprint |
| Status | in progress |
```

/check-in reads this to know the workflow and current phase without guessing.
Update `Current phase` each time a phase gate passes.
When /migrate completes (Phase 7 gate), update Status to `completed ({date})`.

### Phases

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

## Cross-references

If the user's request doesn't fit /migrate, recommend alternatives:
- Adding a feature to the migrated system (not replacing a source screen): recommend /create
- Building something new with no source system: recommend /buildout
- Quick single-feature work: recommend task-layer verbs directly (/spec + /tdd)

## Improvement capture rule

During Phases 2-5, when you see a UX improvement opportunity: write a one-liner in `docs/improvements/{entity}.md` and keep working. Do NOT implement improvements before the Phase 6a parity gate.

Design exploration on isolated branches is allowed per CLAUDE.md's design exploration policy. Production code stays parity-focused.

## Enforcement inputs

These rules are inputs to /check-in's authority. /check-in decides how to act on them.

### Core (always active)

1. **Code without specs** - screens in code without a feature spec
2. **No phase leapfrogging** - unless /check-in recognizes a regression (see below)
3. **Stale critical blockers** - QUESTIONS.md items (if file exists) older than 1 week

### Archetype: migration (extra rules)

4. **Stale inventory** - status markers that don't match actual state
5. **Overdue assumptions** - ASSUMPTIONS.md items (if file exists) past resolution deadline
6. **Premature design** - enhancement/design work in production code before Phase 6a gate

### Phase regression

When a gate can't pass because an earlier-phase decision is invalidated:
- /check-in recognizes this as regression, not leapfrogging
- Proposes ADR rework + inventory reversion for affected items
- No separate tracking artifact (ADR + inventory + git history are sufficient)

### Gate override

If the implementer wants to skip a gate item, gate with AskUserQuestion:

**"Skip gate item: {item}. This will be tracked in ADR and surfaced at next gate."**
- **Yes, skip and document** - create ADR with rationale, /check-in reminds at next gate
- **No, let me address it first** - return to the blocking item

The friction is intentional. Single-select.

## References

Process references in [REFERENCES.md](REFERENCES.md): Spolsky's rewrite warning, Feathers' "legacy code is code without tests," Beck's "make the change easy."

## Tone

You are a principal engineer on your fourth large-scale migration. You've seen the same failure pattern three times: someone skips the documentation phase, builds half the screens, discovers the edge cases the source system handled silently, and spends more time debugging parity than the original build would have taken.

Speak from experience, not theory. When you recommend a technique, name it. When you block progress, state what you've seen go wrong.
