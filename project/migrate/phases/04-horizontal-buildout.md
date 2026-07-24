# Phase 4 - Horizontal Buildout

**Goal:** systematically port all remaining screens.

## Checkpoints

### CP1: Pre-build spec prerequisite (per screen)
- **Trigger:** before building each screen
- **References:** feature spec, logic doc, CONVENTIONS.md, CONCERNS.md
- **Action:** verify spec exists and is complete. If missing: block - leaked Phase 2 work. If spec exists but incomplete: flag specific gaps. Invoke `/spec` only if no source system to extract from (new feature not in legacy).
- **Pass:** feature spec and logic doc exist, are cross-referenced against source, and no related assumptions in CONCERNS.md are past their resolution deadline.

### Post-build (per screen)
- **Trigger:** when `/port` reports a screen complete
- **References:** CONCERNS.md (entity concerns), CONVENTIONS.md, GLOSSARY.md
- **Action:** /port suggests /wrapup. If invoked: /wrapup resolves concerns, cascades to shared docs, updates inventory to `[P]`. If skipped: concerns persist, /check-in surfaces next session.
- **Pass:** /wrapup resolved concerns (or concerns persist for next session).

## Process

Order by dependency (parents before children).

### Per-screen process

Invoke `/port` for each screen. `/port` handles:
1. Read feature spec + logic doc + source system
2. Generate subagent brief
3. Spawn implementation subagent(s)
4. Review output against spec and source
5. Emit discrepancies as concerns in CONCERNS.md
6. Run test suite - zero failures
7. Report complete (signals contract: suggests /wrapup)

### Concurrency

Primary fan-out opportunity. Multiple agents can build different screens IF:
- Non-overlapping entities claimed in CONCERNS.md (see [../../../CONCERNS-FORMAT.md](../../../CONCERNS-FORMAT.md#claims-section) for format)
- Shared infra changes (router, shared components, types) are single-threaded
- One agent proposes shared changes, merges; others pull

### Testing acceptance criteria

At horizontal buildout scale:
- Every ported screen has at least one test verifying its primary workflow
- The full test suite passes after each screen is added
- No regressions in previously-ported screens

Testing methodology (structural enforcement, snapshots, characterization tests) is owned by /port, not this phase file.

## Gate

- [ ] All in-scope entities at `[P]`
- [ ] Test suite: zero failures
- [ ] No process violations (all /wrapup runs passed or flags documented)
- [ ] Inventory current and accurate
