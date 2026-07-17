# Phase 4 - Horizontal Buildout

**Goal:** systematically port all remaining screens.

Order by dependency (parents before children).

## Per-screen process

1. Read feature spec + logic doc
2. Build: route -> view -> data -> mock data -> tests
3. Cross-reference against source system
4. Fix code AND docs where discrepancies found
5. Run test suite - zero failures
6. Mark `[P]` in inventory

## Concurrency

Primary fan-out opportunity. Multiple agents can build different screens IF:
- Non-overlapping entities claimed in ACTIVE-WORK
- Shared infra changes (router, shared components, types) are single-threaded
- One agent proposes shared changes, merges; others pull

## Enforcement

- Screen built without spec -> stop, write spec first
- New pattern not in ARCHITECTURE.md -> document or use existing pattern
- Tests failing -> fix before marking `[P]`
- UX improvement spotted -> capture in `docs/improvements/`, keep porting

## Gate

- [ ] All in-scope entities at `[P]`
- [ ] Test suite: zero failures
- [ ] No process violations
- [ ] Inventory current and accurate
