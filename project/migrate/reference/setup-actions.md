# Setup Actions

## Source system scoping

Add a `## Source System` section to SCOPE.md:

- **What is it?** Stack, age, approximate size (screens, entities, integrations).
- **Where is the source code?** Can agents read it?
- **Running instance?** URL for side-by-side comparison.

## Parity decision

Two sequential AskUserQuestion gates:

**Q1: "What's the migration strategy?"**
- **1:1 parity port (Recommended)** - replicate source behavior exactly, improve later in Phase 6b
- **Selective redesign** - port core, redesign specific areas (user lists which areas and why)
- **Full redesign** - new UX informed by old, not constrained by it

**Q2: "What's the cutover approach?"**
- **Strangler fig (Recommended)** - incremental, run both systems, shift traffic gradually
- **Big-bang** - build everything, cut over at once
- **Parallel run** - both systems live, compare output, switch when confident

If the combination creates tension (e.g., full redesign + strangler fig), note it conversationally after both answers - don't filter options.

Store both answers in SCOPE.md `## Source System` section.

Reference: Fowler's Strangler Fig - build new alongside old, route traffic gradually.
Reference: Spolsky's rewrite warning - old code embodies years of bug fixes.

## What NOT to build

- Which legacy features are deprecated, unused, or superseded?
- Which features exist only because of old tech constraints?
- Mark these OUT in SCOPE.md with brief justification.

## Inventory setup

Create or verify the inventory tracker (e.g., `docs/inventory-plugins.md`) with columns for each phase marker: `[ ]` -> `[D]` -> `[S]` -> `[P]` -> `[M]` -> `[V]`.
