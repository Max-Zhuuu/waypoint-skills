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
- **Action:** invoke /grill-with-docs for any decision meeting ADR threshold. Spawn review agent. Run doc sync. Update CONVENTIONS.md with patterns that emerged. Refine TESTING.md with test patterns that proved valuable.
- **Pass:** architecture grill complete, review passed, CONVENTIONS.md and TESTING.md updated, spec matches build.

### Post-build (per feature)
- **Trigger:** when /tdd reports a feature complete
- **Action:** spawn review agent. Run doc sync. Update SCOPE.md to mark feature complete.
- **Pass:** review passed, spec matches build, shared docs current.

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

### Testing the MVP

Follow the testing trophy (Kent C. Dodds), not the testing pyramid. Integration tests give the most confidence per test written.

Write tests the way the user uses the feature. State the hypothesis first: "If the user does X, then Y should happen because Z."

For hobby projects with limited testing time: one smoke test per feature + one integration test for the primary workflow.

### Build remaining Must features

For each Must feature from the MoSCoW list:
1. CP1 fires (pre-build spec check)
2. Invoke `/tdd`
3. Post-build checkpoint fires
4. Mark complete in SCOPE.md

Order by dependency chain, then by risk.

### Concurrency

If working with multiple agents, each agent claims features in `docs/local/ACTIVE-WORK.md`. No two agents build the same feature. Each agent reads the spec before building.

## When to stop

MVP is done when all Must features work end-to-end.
Not polished. Not optimized. Not beautiful.
Working, demoable, and solving the core problem.

## Gate

- [ ] Vertical slice complete and architecture validated (CP2 passed)
- [ ] All Must features built and working
- [ ] No architectural concerns deferred
- [ ] Can demo the product to someone and they understand what it does
