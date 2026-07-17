---
name: migrate
description: Migration methodology extending /project-setup with source system analysis, parity validation, and phased buildout. Use at migration start, between phases, when process discipline has slipped, or when the user says "migrate", "migration status", "what phase".
disable-model-invocation: true
---

# Migrate

Extends `/project-setup` with migration-specific phases for porting legacy systems.
Enforces strict phase gates. Refuses to let you skip steps.

## Orientation (print this on every invocation)

Before doing any work, print a compact orientation block:

```
/migrate - You are here. Migration-specific phases extending /project-setup.
  Phase 0-1: Foundation       (handled by /project-setup)
  Phase 2:   Doc sprint       -> spec every entity before coding (02-documentation-sprint.md)
  Phase 3:   Vertical slice   -> validate architecture with 3 screens (03-vertical-slice.md)
  Phase 4:   Horizontal build -> port all remaining screens (04-horizontal-buildout.md)
  Phase 5:   Integration      -> replace mock data with real API (05-integration.md)
  Phase 6a:  Parity check     -> functional validation, design doesn't matter yet (06a-functional-validation.md)
  Phase 6b:  Design pass      -> apply visual system + improvements uniformly (06b-design-pass.md)
  Phase 7:   Cutover          -> ship it (07-cutover.md)

  Key rule: capture UX improvements in docs/improvements/, don't implement until 6a passes.
  Key rule: no code without a spec. No spec without a logic doc.

Related: /spec (feature reqs), /grill-with-docs (ADRs), /reorient (strategic checkpoint), /learn (trade-offs)
```

Then state: current phase, gate status, and any violations detected.

## Prerequisites

`/project-setup` must have been run first. Check for:
- SCOPE.md exists
- DEPENDENCIES.md exists
- CLAUDE.md exists with process definition
- Documentation structure exists

If any are missing, tell the user to run `/project-setup` first. Do not proceed without the foundation.

## How this skill works

1. Detect current phase from project state (inventory markers, docs, git history).
2. Run enforcement checks (bottom of this file).
3. Report violations before phase work.
4. Check gate criteria. If met: prompt to advance. If not: show blockers.
5. Delegates to: `/grill-with-docs` for decisions, `/learn` for understanding, `/reorient` for checkpoints, `/spec` for feature requirements.

## Phase overview

| Phase | Name | File |
|-------|------|------|
| 0-1 | Setup | Handled by `/project-setup` |
| 2 | Documentation sprint | [02-documentation-sprint.md](02-documentation-sprint.md) |
| 3 | Vertical slice | [03-vertical-slice.md](03-vertical-slice.md) |
| 4 | Horizontal buildout | [04-horizontal-buildout.md](04-horizontal-buildout.md) |
| 5 | Integration | [05-integration.md](05-integration.md) |
| 6a | Functional validation | [06a-functional-validation.md](06a-functional-validation.md) |
| 6b | Design pass | [06b-design-pass.md](06b-design-pass.md) |
| 7 | Cutover | [07-cutover.md](07-cutover.md) |

Read only the file for the current phase. Each file contains detailed instructions and gate criteria.

## Migration-specific scoping (extends Phase 0)

During `/project-setup` Phase 0, the following migration-specific questions must also be resolved:

**Source system:**
- What is it? (stack, age, approximate size: screens, entities, integrations)
- Where is the source code? Can agents read it?
- Is there a running instance for side-by-side comparison?

**Parity decision:**
- 1:1 port or redesign? If redesign: what changes and why?
- Strangler fig (incremental replacement) or big-bang (full rewrite, cutover)?
- Reference: Fowler's Strangler Fig pattern - build new alongside old, route traffic gradually
- Reference: Spolsky's rewrite warning - old code embodies years of bug fixes; don't discard lightly

**What NOT to build:**
- Which legacy features are deprecated, unused, or superseded?
- Which features exist only because of old tech constraints (e.g., desktop-only workflows)?
- Mark these OUT in SCOPE.md with brief justification

Add a `## Source System` section to SCOPE.md with: stack, location, running instance URL, parity decision.

## Improvement capture rule

During Phases 2-5, when you see a UX improvement opportunity: write a one-liner in `docs/improvements/{entity}.md` and keep working. Do NOT implement improvements before the Phase 6a parity gate is met.

Design exploration on isolated branches (worktree, design branch) is allowed per the Design Exploration Policy in CLAUDE.md. Production code stays parity-focused.

## Enforcement

On every invocation, before phase work:

1. **Code without specs** - screens that exist in code without a feature spec
2. **Stale inventory** - status markers that don't match actual state
3. **Overdue assumptions** - ASSUMPTIONS.md items past resolution deadline
4. **Stale questions** - critical QUESTIONS.md items older than 1 week
5. **Phase leapfrogging** - Phase N+1 work while Phase N gate is unmet
6. **Premature design** - enhancement/design work in production code before Phase 6a gate

Report violations first. Require acknowledgment before proceeding.

### Gate override

If the implementer wants to skip a gate item:
- State which item and why
- Document in `docs/adr/` as a decision: what was skipped, why, risk accepted
- The skill records this and reminds at the next gate

## Tone

Project manager who has seen migrations fail.
"You should consider..." -> "Do this."
"It might be good to..." -> "Required before proceeding."
