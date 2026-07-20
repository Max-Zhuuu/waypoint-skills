# Phase 3 - MVP Build

**Goal:** build the smallest thing that proves the concept works.

## Checkpoints

### CP1: Pre-build spec check (per Must feature)
- **Trigger:** before building each Must feature
- **References:** feature spec (from /spec), CONVENTIONS.md, ASSUMPTIONS.md
- **Action:** verify spec exists via /spec. If missing: invoke /spec before proceeding. Verify CONVENTIONS.md exists (seed in Phase 1, refine here). Verify no unresolved critical assumptions.
- **Pass:** spec exists and is complete, CONVENTIONS.md current, no blocking assumptions.

### CP2: Post-slice architecture review
- **Trigger:** after the vertical slice (first Must feature) is built and passing tests
- **References:** feature spec, CONVENTIONS.md, ADR folder, TESTING.md
- **Action:** invoke /grill-with-docs for any decision meeting ADR threshold. Run /wrapup to resolve flags and cascade to shared docs.
- **Pass:** architecture grill complete, /wrapup passed, no unresolved flags.

### Post-build (per feature)
- **Trigger:** when implementation verb reports complete
- **Action:** suggest /wrapup. Update SCOPE.md to mark feature complete.
- **Pass:** /wrapup resolved flags (or flags persist for next session if skipped).

## Process

### Pick the vertical slice

Choose one Must feature that:
1. Touches the most architectural layers (routing, state, data, UI)
2. Is the hardest to get right (the one you're least sure about)
3. Is demoable - someone can use it and give feedback

Build it end-to-end using `/tdd`. This is your architecture proof.

### Architecture checkpoint

After the vertical slice works (fires CP2):
- Does the component structure feel right, or are you fighting it?
- Is state management clear, or is data flowing in confusing ways?
- Is the data model clean, or are you working around it?

If something feels wrong, fix it now. This is cheaper to fix with 1 feature than with 10.

### Testing acceptance criteria

Each Must feature must have:
- At least one test covering the primary user workflow end-to-end
- No test failures in the suite after the feature is built

Testing methodology (what kind of tests, what style, what patterns) is owned by the implementation verb, not this phase file.

### Build remaining Must features

For each Must feature from the MoSCoW list:
1. CP1 fires (pre-build spec check)
2. Invoke chosen implementation verb (via /check-in methodology selection)
3. Verb reports complete, suggests /wrapup
4. Mark complete in SCOPE.md

Order by dependency chain, then by risk.

### Concurrency

If working with multiple agents, each agent claims features in `docs/local/ACTIVE-WORK.md` (see [project-setup/REFERENCES.md](../project-setup/REFERENCES.md#hook-catalog) for setup). No two agents build the same feature. Each agent reads the spec before building.

## When to stop

MVP is done when all Must features work end-to-end.
Not polished. Not optimized. Not beautiful.
Working, demoable, and solving the core problem.

## Gate

- [ ] Vertical slice complete and architecture validated (CP2 passed)
- [ ] All Must features built and working
- [ ] No architectural concerns deferred
- [ ] Can demo the product to someone and they understand what it does
