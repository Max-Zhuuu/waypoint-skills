---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### Documentation landscape

Check what documentation structure exists before starting. Read the project's CLAUDE.md for the full layout.

**Always look for:**
- `CONTEXT.md` (or `CONTEXT-MAP.md` for multi-context repos) - domain glossary
- `docs/adr/` - architecture decision records
- `SCOPE.md` - what's in, out, uncertain
- `CONVENTIONS.md` - naming patterns
- `DEPENDENCIES.md` - external system status
- `TESTING.md` - test expectations
- `docs/reference/features/` and `docs/reference/logic/` - per-entity specs

If none of these exist, create files lazily - only when you have something to write.
If `CONTEXT.md` doesn't exist, create one when the first term is resolved.
If `docs/adr/` doesn't exist, create it when the first ADR is needed.

If scaffolding is missing, follow [ENGAGEMENT-REFERENCE.md](../ENGAGEMENT-REFERENCE.md).

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` should be totally devoid of implementation details. Do not treat `CONTEXT.md` as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Cascade to other project docs

When a grill decision affects project-wide docs beyond CONTEXT.md, update them inline too:
- New naming pattern resolved -> update CONVENTIONS.md
- Scope changed (in/out/uncertain shifted) -> update SCOPE.md
- Dependency status changed -> update DEPENDENCIES.md
- Test expectations changed -> update TESTING.md
- Entity-level decision -> update the entity's feature spec or logic doc if one exists

Only cascade when the doc exists and the change is genuine. Don't create docs just to cascade into them.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
