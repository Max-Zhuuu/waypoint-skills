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

If changes needed: update ADRs, update skeleton, re-validate all 3.
Do NOT proceed with a known-broken pattern.

## Characterization tests

For complex screens, consider characterization tests (golden master approach): capture the legacy system's output for specific inputs, then assert the new system matches. Proves parity without understanding every edge case.

## Gate

- [ ] 3 screens working end-to-end with mock data
- [ ] All 3 cross-referenced against source system
- [ ] Architecture checkpoint documented
- [ ] Required changes applied and validated
- [ ] Test patterns established
- [ ] Inventory shows 3 screens at `[P]`
