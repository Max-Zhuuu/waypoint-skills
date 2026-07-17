# Phase 3 - MVP Build

**Goal:** build the smallest thing that proves the concept works.

## Pick the vertical slice

Choose one Must feature that:
1. Touches the most architectural layers (routing, state, data, UI)
2. Is the hardest to get right (the one you're least sure about)
3. Is demoable - someone can use it and give feedback

Build it end-to-end. This is your architecture proof. If the stack holds for this feature, it holds for the rest.

### Architecture checkpoint

After the vertical slice works:
- Does the component structure feel right, or are you fighting it?
- Is state management clear, or is data flowing in confusing ways?
- Is the data model clean, or are you working around it?
- Are there patterns emerging that should be documented as conventions?

If something feels wrong, fix it now. Invoke `/grill-with-docs` for any decision that deserves an ADR.
Invoke `/learn` if you're choosing between approaches and want to understand the trade-offs.
This is cheaper to fix with 1 feature than with 10.

## Build remaining Must features

For each Must feature from the MoSCoW list:
1. Run `/spec` if not already done
2. Build against the spec
3. Test it works (manual or automated, your call for hobby projects)
4. Mark complete in SCOPE.md

Order by dependency chain, then by risk. Build the uncertain ones first.

### Concurrency note

If working with multiple agents, each agent claims features in `docs/local/ACTIVE-WORK.md`.
No two agents build the same feature.
Each agent reads the spec before building.

## When to stop

MVP is done when all Must features work end-to-end.
Not polished. Not optimized. Not beautiful.
Working, demoable, and solving the core problem.

Resist the urge to add Should features before shipping.
Ship the ugly thing, get feedback, then decide what matters.

## Gate

- [ ] Vertical slice complete and architecture validated
- [ ] All Must features built and working
- [ ] No architectural concerns deferred
- [ ] Can demo the product to someone and they understand what it does
