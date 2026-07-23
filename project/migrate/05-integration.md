# Phase 5 - Integration

**Goal:** replace all mock data with real API calls.

## Checkpoints

### CP1: Pre-wire dependency check (per screen)
- **Trigger:** before wiring each screen to the real API
- **References:** ARCHITECTURE.md (External Dependencies), feature spec, logic doc, mock data file
- **Action:** verify the API endpoint exists and is available. Compare mock data shape against actual API response shape. If shapes differ: classify (mock wrong vs API wrong vs intentional divergence) using the resolution cascade (source code -> test case -> human). If endpoint unavailable: emit a concern (type: question), keep mock as fallback.
- **Pass:** API endpoint available, shape validated or discrepancies resolved, ARCHITECTURE.md (External Dependencies) current.

### Post-wire (per screen)
- **Trigger:** when integration is complete for a screen
- **References:** feature spec, ARCHITECTURE.md (External Dependencies), API response shape
- **Action:** emit any discrepancies as concerns in CONCERNS.md (type: issue, source: integration). Suggest /wrapup. Update inventory marker to `[M]`.
- **Pass:** /wrapup resolved concerns (or concerns persist), loading/error/empty states implemented, inventory updated.

## Process

### Prerequisites

Review ARCHITECTURE.md (External Dependencies):
- Is the API available? If partial: which endpoints?
- Does API shape match mock data? What's the gap?
- If not ready: partial integration or wait?

### Per-screen wiring

1. Replace mock data with API calls
2. Implement loading, error, empty states
3. Verify data shape (types catch most; edge cases surface here)
4. Test with real data
5. Report complete (triggers post-wire checkpoint)

### Contract tests

If frontend and backend teams work on different timelines, write contract tests: the frontend describes what it expects from each endpoint, the backend runs the same contract against its implementation.

At minimum, add smoke tests that hit each real endpoint and verify it returns the expected shape.

### When API doesn't match

Apply the resolution cascade (see README.md > Key Concepts > Resolution Cascade).

Then:
- API wrong: file bug with backend, emit concern (type: question), keep mock as fallback
- Mock wrong: fix frontend, update spec, add Change Log entry

## Gate

- [ ] All screens consuming real API (or documented exceptions)
- [ ] No mock data in production code paths
- [ ] Loading/error/empty states implemented
- [ ] All items at `[M]`
