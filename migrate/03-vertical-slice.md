# Phase 3 - Vertical Slice

**Goal:** validate architecture with 3 real screens before scaling.

This is the most important gate. Skipping it means discovering broken patterns after 30 screens.

## Checkpoints

### CP1: Pre-build spec check
- **Trigger:** before building each of the 3 screens
- **References:** feature spec, logic doc, CONVENTIONS.md, ASSUMPTIONS.md
- **Action:** verify spec exists and is complete (all sections filled). Verify logic doc exists. If missing: block - this is leaked Phase 2 work. If spec exists but source system files aren't cross-referenced: flag, allow with acknowledgment.
- **Pass:** all four reference files exist and are current for this entity.

### CP2: Post-slice architecture review
- **Trigger:** after all 3 screens are built and passing tests
- **References:** all 3 feature specs, CONVENTIONS.md, ADR folder, source system files, TESTING.md
- **Action:** invoke `/grill-with-docs` for any decision that meets the ADR threshold (hard to reverse, surprising, real trade-off). Spawn review agent per screen. Run doc sync (update specs where build diverged, cascade to shared docs). Update CONVENTIONS.md with patterns that emerged. Refine TESTING.md with test patterns that proved valuable.
- **Pass:** architecture grill complete (no unresolved ADR-worthy decisions), review agents passed, CONVENTIONS.md and TESTING.md updated, all 3 specs match their builds.

## Process

### Pick 3

1. **Simple** - basic list + detail. Tests: routing, layout, data fetching, form.
2. **Medium** - relationships, conditional logic, tabs. Tests: state management, composition, navigation.
3. **Complex** - most fields, most rules, most integrations. Tests: performance, edge cases, pattern limits.

Present picks and justify why these 3 cover the architecture.

### Build end-to-end

For each screen, invoke `/port`. Cross-reference against source system side-by-side.

### Architecture checkpoint

After all 3 (fires CP2):
- What worked as designed?
- What required workarounds?
- What needs to change before Phase 4?
- What naming patterns emerged? Update CONVENTIONS.md.

If changes needed: update ADRs, update skeleton, re-validate all 3.
Do NOT proceed with a known-broken pattern.

### Characterization tests (Feathers)

For complex screens, write characterization tests (golden master approach): capture the legacy system's actual output for a set of inputs, then assert the new system matches. Don't assert what the output *should* be - assert what it *is*.

Discrepancies are either bugs in the migration or intentional improvements - categorize each one explicitly.

## Gate

- [ ] 3 screens working end-to-end with mock data
- [ ] All 3 cross-referenced against source system
- [ ] CP2 passed (architecture grill, reviews, doc sync)
- [ ] Required changes applied and validated
- [ ] CONVENTIONS.md and TESTING.md refined from real patterns
- [ ] Inventory shows 3 screens at `[P]`
