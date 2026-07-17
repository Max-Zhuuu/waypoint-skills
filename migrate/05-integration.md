# Phase 5 - Integration

**Goal:** replace all mock data with real API calls.

## Prerequisites

Review DEPENDENCIES.md:
- Is the API available? If partial: which endpoints?
- Does API shape match mock data? What's the gap?
- If not ready: partial integration or wait?

## Per-screen wiring

1. Replace mock data with API calls
2. Implement loading, error, empty states
3. Verify data shape (types catch most; edge cases surface here)
4. Test with real data
5. Mark `[M]` in inventory

## When API doesn't match

1. Check spec: is mock wrong or API wrong?
2. API wrong: file bug with backend, document in QUESTIONS.md, keep mock as fallback
3. Mock wrong: fix frontend, update spec, add Change Log entry

## Gate

- [ ] All screens consuming real API (or documented exceptions)
- [ ] No mock data in production code paths
- [ ] Loading/error/empty states implemented
- [ ] All items at `[M]`
