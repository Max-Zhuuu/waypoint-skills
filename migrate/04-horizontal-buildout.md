# Phase 4 - Horizontal Buildout

**Goal:** systematically port all remaining screens.

## Checkpoints

### CP1: Pre-build spec prerequisite (per screen)
- **Trigger:** before building each screen
- **References:** feature spec, logic doc, CONVENTIONS.md, ASSUMPTIONS.md
- **Action:** verify spec exists and is complete. If missing: block - leaked Phase 2 work. If spec exists but incomplete: flag specific gaps. Invoke `/spec` only if no source system to extract from (new feature not in legacy).
- **Pass:** feature spec and logic doc exist, are cross-referenced against source, and have no `[ASSUMPTION]` markers older than their resolution deadline.

### Post-build (per screen)
- **Trigger:** when `/port` reports a screen complete
- **Action:** spawn review agent (Sonnet 5:1 for moderate, Opus 3:1 for high complexity). Run doc sync: diff build against spec, update mechanical diffs, flag intentional deviations, cascade to shared docs. Update inventory marker to `[P]`.
- **Pass:** review passed, spec matches build, shared docs current, inventory updated.

## Process

Order by dependency (parents before children).

### Per-screen process

Invoke `/port` for each screen. `/port` handles:
1. Read feature spec + logic doc + source system
2. Write characterization tests
3. Build: route -> view -> data -> mock data -> tests
4. Cross-reference against source system
5. Fix code AND docs where discrepancies found
6. Run test suite - zero failures
7. Report complete (triggers post-build checkpoint)

### Concurrency

Primary fan-out opportunity. Multiple agents can build different screens IF:
- Non-overlapping entities claimed in ACTIVE-WORK.md
- Shared infra changes (router, shared components, types) are single-threaded
- One agent proposes shared changes, merges; others pull

### Testing at scale

Structural enforcement tests are the safety net at this scale. These verify conventions automatically: every route has a feature spec, every form uses sanctioned control types, every list view has mock data, every screen has scoped styles.

Snapshot each screen after porting. Approval tests lock in the migrated state so later changes can't silently break screens you're not actively touching.

## Gate

- [ ] All in-scope entities at `[P]`
- [ ] Test suite: zero failures
- [ ] No process violations (all post-build checkpoints passed)
- [ ] Inventory current and accurate
