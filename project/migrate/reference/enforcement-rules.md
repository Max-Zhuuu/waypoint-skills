# Enforcement Rules

These rules are inputs to /check-in's authority. /check-in decides how to act on them.

## Improvement capture

During Phases 2-5, when you see a UX improvement opportunity: write a one-liner in `docs/improvements/{entity}.md` and keep working. Do NOT implement improvements before the Phase 6a parity gate.

Design exploration on isolated branches is allowed per CLAUDE.md's design exploration policy. Production code stays parity-focused.

## Core (always active)

1. **Code without specs** - screens in code without a feature spec
2. **No phase leapfrogging** - unless /check-in recognizes a regression (see below)
3. **Stale critical concerns** - flags or questions in CONCERNS.md older than 1 week

## Archetype: migration (extra rules)

4. **Stale inventory** - status markers that don't match actual state
5. **Overdue assumptions** - assumptions in CONCERNS.md past resolution deadline
6. **Premature design** - enhancement/design work in production code before Phase 6a gate

## Phase regression

When a gate can't pass because an earlier-phase decision is invalidated:
- /check-in recognizes this as regression, not leapfrogging
- Proposes ADR rework + inventory reversion for affected items
- No separate tracking artifact (ADR + inventory + git history are sufficient)

## Gate override

If the implementer wants to skip a gate item, gate with AskUserQuestion:

**"Skip gate item: {item}. This will be tracked in ADR and surfaced at next gate."**
- **Yes, skip and document** - create ADR with rationale, /check-in reminds at next gate
- **No, let me address it first** - return to the blocking item

The friction is intentional. Single-select.
