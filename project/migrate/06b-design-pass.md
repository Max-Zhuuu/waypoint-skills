# Phase 6b - Design Pass

**Goal:** formalize the design system and implement UX improvements.

Only begin after Phase 6a gate is met. This is the reward for disciplined parity work.

Design exploration during build phases (3-5) is encouraged but unmanaged - ideas captured in docs/improvements/, experiments on design branches, nothing merges until this phase.

## Sub-phases

### 6b-i: Design System (shared - both migrate and buildout)

Formalize the design system, close gaps, establish variants.

### 6b-ii: UX Improvements (migration-only)

Structured refinement of the complete product surface.

---

## 6b-i: Design System

### Process (what to do)

1. **Audit** - catalog all component types and their current styling patterns. Identify inconsistencies, gaps, and overloaded patterns.
2. **Resolve gaps** - define missing patterns, consolidate duplicates, establish hierarchy.
3. **Validate** - test the system on the densest/most complex screens. Get feedback from a non-builder.
4. **Document** - write DESIGN-SYSTEM.md covering the system's architecture and how to extend it.

### Methodology

The *how* of design system work (token architecture, semantic layering, density modes, CSS approach) belongs to the user's design methodology skill. Invoke via AskUserQuestion:

"Which design skill for 6b-i? /design, /soft, /taste, or other?"

The chosen skill owns the methodology. This phase file owns the acceptance criteria.

### Gate (6b-i)

- [ ] All component types use the design system consistently (no orphan patterns)
- [ ] Design system works across all screens without layout breakage
- [ ] All audit gaps resolved or deferred with rationale
- [ ] DESIGN-SYSTEM.md written and covers how to extend the system
- [ ] At least one feedback round with a non-builder

---

## 6b-ii: UX Improvements (migration-only)

### Process (what to do)

1. **Triage** - review all items in docs/improvements/. Classify each by scope (token/component/page) and impact. After triage, present the prioritized list grouped by tier and gate with AskUserQuestion: **"Build in this order?"** Accept or adjust. Tier ordering is prescribed (token -> component -> page); priority within tiers is the user's call.
2. **Research** - for component-level and page-level improvements, research comparable solutions before building. Token-level changes can proceed directly.
3. **Build** - invoke chosen methodology skill. Work top-down (page flow before component behavior before micro-polish).
4. **Validate** - verify no functional regressions (re-run 6a spot checks on modified screens).

### Impact classification

When an improvement requires backend work:
- **Tier 1 (frontend-only):** proceed.
- **Tier 2 (API-shape change):** write design brief + data contract in docs/local/handoffs/api-contracts/. Build against mock. Don't block.
- **Tier 3 (schema/logic change):** invoke /grill-with-docs for ADR. Write handoff in docs/local/handoffs/schema-changes/. Pause until resolved.

### Feedback

All feedback flows into FEEDBACK.md with level tags (macro/meso/micro) and observations structured as: what worked, what confused, what they asked for.

### Gate (6b-ii)

- [ ] All promoted improvements built or deferred with rationale
- [ ] At least one feedback round with a non-builder on navigation/workflow changes
- [ ] No functional regressions
- [ ] Feature specs updated for all changed screens (via /wrapup)
- [ ] docs/improvements/ fully triaged (every item built, deferred, or killed)
