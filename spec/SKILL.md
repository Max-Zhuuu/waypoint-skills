---
name: spec
description: Feature-level requirements skill. Grills on scope and acceptance criteria, outputs a spec file. Use when starting a new feature, when requirements are vague, or when the user says "spec this", "write a spec", "PRD".
---

# Spec

Takes a feature idea from vague to precise. Outputs a spec file that any developer or agent can build from.

Grills on scope and acceptance criteria inline (not AskUserQuestion). Outputs a spec file. Updates CONTEXT.md if new domain terms surface. Triggers /grill-with-docs if the feature needs an architecture decision.

Hard prerequisite in buildout (every Must feature needs a spec). Conditional in migration (only when no source system to extract from, or when an improvement is promoted from docs/improvements/).

## Phase 1 - Scope the feature

Read any existing context: SCOPE.md, CONTEXT.md, ARCHITECTURE.md, related specs in `docs/specs/`.

Then grill inline. Print questions with your recommended answer so the implementer can challenge back. Do not use `AskUserQuestion`.

**Problem:**
- What problem does this feature solve?
- Who experiences this problem? (specific user role, not "users")
- How do they work around it today?

**Solution shape:**
- One sentence: what does this feature do?
- Where does it live in the app? (existing screen, new screen, background process)
- What's the smallest version that solves the problem? (MVP cut)

**Scope boundaries:**
- What's IN for v1?
- What's explicitly OUT? (adjacent features, nice-to-haves, future enhancements)
- What depends on this feature? What does it depend on?

**If migration context exists:** check whether this feature exists in the source system. If yes, is this a parity port or an enhancement? If enhancement, it belongs in `docs/improvements/` until Phase 6b parity gate is met (per `/migrate` rules).

## Phase 2 - Define acceptance criteria

For each behavior in scope, write a Given/When/Then acceptance criterion:

```
**Given** the user is on the vessel list
**When** they type in the search box
**Then** the list filters to vessels matching the query by name or IMO number
```

Also define:
- **Error states:** what happens when things go wrong (network failure, empty results, invalid input)
- **Edge cases:** boundary conditions the implementer might miss
- **Out-of-scope interactions:** explicitly state what this feature does NOT affect

### Present options where trade-offs exist

When a requirement has multiple valid approaches, present 2-3 options inline with your recommendation:

```
Search implementation:

1. **Client-side filter (Recommended)** - filter the already-loaded list in memory.
   Wins when: dataset is small (<1000 rows), no API cost per keystroke.

2. **Server-side search** - debounced API call on each keystroke.
   Wins when: dataset is large, need relevance ranking or fuzzy matching.

3. **Hybrid** - load first page client-side, switch to server on query.
   Wins when: dataset is medium, want fast initial results with full coverage.

Recommendation: option 1 - vessel list is <200 rows in typical deployments,
and the data is already fetched for the list view.
```

Mark the recommendation and state why. The implementer picks or challenges.

## Phase 3 - Write the spec

Output to `docs/specs/{feature-slug}.md`:

```markdown
# {Feature Name}

**Status:** Draft | Approved | In Progress | Done
**Author:** {who wrote it}
**Date:** {date}
**Target branch:** {which branch tier}

## Problem
{One paragraph from Phase 1}

## Solution
{One paragraph: what it does, where it lives}

## Scope
### In
- {bullet list}

### Out
- {bullet list}

## Acceptance Criteria
{Given/When/Then blocks from Phase 2}

## Error States
{Table or bullets}

## Dependencies
- {What this feature needs: APIs, other features, data}
- {What depends on this feature}

## Open Questions
{Anything unresolved - who to ask, by when}

## Change Log
{Date - one liner, added as spec evolves}
```

## Phase 4 - Update shared artifacts

1. If new domain terms surfaced: update `CONTEXT.md` (domain terms only, not general programming concepts).
2. If the feature involves an architecture decision (new pattern, new state management approach, new API convention): suggest invoking `/grill-with-docs` for an ADR.
3. If the feature should be tracked in an inventory or roadmap: add it.

## Bridge behavior

/spec is a bridge skill: fully functional standalone, enhanced by project scaffolding.

**Integration points when scaffolding exists:**
- SCOPE.md: cross-reference scope boundaries, check if feature is in/out/uncertain
- CONVENTIONS.md: enforce naming patterns in the spec output
- CONTEXT.md: validate domain terms against the glossary, flag new terms for Phase 4

**Without scaffolding:** core grill loop works. No scope cross-referencing, no convention enforcement, no term validation. All outputs still produced.

If scaffolding is missing, follow [LIGHTWEIGHT-REFERENCE.md](../LIGHTWEIGHT-REFERENCE.md).

## Tone

Concise. A spec is a contract, not a narrative.
Every sentence should either constrain scope or define behavior.
If a sentence does neither, cut it.
