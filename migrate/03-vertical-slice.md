# Phase 3 - Vertical Slice

**Goal:** validate architecture with 3 real screens before scaling.

This is the most important gate. Skipping it means discovering broken patterns after 30 screens.

## Pick 3

1. **Simple** - basic list + detail. Tests: routing, layout, data fetching, form.
2. **Medium** - relationships, conditional logic, tabs. Tests: state management, composition, navigation.
3. **Complex** - most fields, most rules, most integrations. Tests: performance, edge cases, pattern limits.

Present picks and justify why these 3 cover the architecture.

## Build end-to-end

For each: route -> layout -> view -> data layer -> mock data -> tests.
Cross-reference against source system side-by-side.

## Architecture checkpoint

After all 3:
- What worked as designed?
- What required workarounds?
- What needs to change before Phase 4?
- What naming patterns emerged? Update `CONVENTIONS.md` - these 3 screens set the precedent for Phase 4.

If changes needed: update ADRs, update skeleton, re-validate all 3.
Do NOT proceed with a known-broken pattern.

## Characterization tests (Feathers)

For complex screens, write characterization tests (golden master approach): capture the legacy system's actual output for a set of inputs, then assert the new system matches. Don't assert what the output *should* be - assert what it *is*. The spec might be incomplete; the golden master isn't. Discrepancies are either bugs in the migration or intentional improvements - categorize each one explicitly.

This is the phase where "legacy code is code without tests" (Feathers) becomes real. Before changing any legacy behavior, lock in the current behavior with a test. Then change. Then verify.

## Gate

- [ ] 3 screens working end-to-end with mock data
- [ ] All 3 cross-referenced against source system
- [ ] Architecture checkpoint documented
- [ ] Required changes applied and validated
- [ ] Test patterns established
- [ ] Inventory shows 3 screens at `[P]`
