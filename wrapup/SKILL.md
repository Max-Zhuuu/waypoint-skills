---
name: wrapup
description: Completion verb. Resolves flags from implementation verbs, cascades to shared docs, evaluates gate criteria. Optional but recommended after each /port or /tdd cycle.
disable-model-invocation: true
inputs:
  - feature-spec: docs/reference/features/{entity}.md (with ## Flags section)
outputs:
  - spec-updated: feature spec with flags resolved and Change Log entry
  - shared-docs: CONVENTIONS.md, CONTEXT.md, DESIGN-SYSTEM.md updated if cascade needed
  - inventory: marker confirmed or advanced
signals: []
---

# Wrapup

The completion verb. Single reconciliation point for all doc updates after implementation.

## Role

/wrapup is the only skill that writes to specs and shared docs after implementation.
It resolves the structured flags that /port (or /tdd) left behind, cascades changes to shared docs, and evaluates whether the gate criteria are met.

## When to invoke

- After /port or /tdd reports complete (suggested by the verb)
- Optional: skip if confident. Flags persist in the spec's ## Flags section.
- If skipped: /check-in surfaces unresolved flags next session as priority-1 work.

## Process

### 1. Read flags

Read the ## Flags section from the feature spec. Each flag is a structured discrepancy:
- Spec vs. reality mismatch
- Missing information discovered during build
- Potential cascade to shared docs

### 2. Resolve each flag

For each flag, apply the resolution cascade (see README.md > Key Concepts > Resolution Cascade).

Resolution outcomes:
- **Spec was wrong** - update the spec, add Change Log entry
- **Build was wrong** - fix the code (or note as a follow-up if non-trivial)
- **Both need updating** - update spec, fix code
- **Intentional difference** - document in spec Change Log with rationale

### 3. Cascade to shared docs

After resolving flags, check whether any resolution affects shared docs:
- New naming pattern emerged -> update CONVENTIONS.md
- New domain term resolved -> update CONTEXT.md
- New token or design pattern -> update DESIGN-SYSTEM.md (if exists)
- Spec structure changed in a way that affects the template -> flag for review

Only cascade when there's a genuine shared-doc change. Don't cascade for entity-local updates.

### 4. Clear flags

Remove the ## Flags section from the spec (all flags resolved or escalated).
If any flags need human input: leave them with `[ESCALATED]` marker and move on.

### 5. Evaluate gate

Check the current phase's gate criteria against project state:
- How many items remain at current phase?
- Are all gate conditions for completed items satisfied?
- Are there blocking issues?

Report:

```
Wrapup complete. {entity} resolved ({N} flags cleared, {M} escalated).
Gate: {X}/{Y} criteria met. Remaining: {list specific items}.
```

## What /wrapup does NOT do

- Does not propose next work (that's /check-in)
- Does not implement features (that's the implementation verb)
- Does not make architectural decisions (that's /grill-with-docs)
- Does not fire enforcement rules (that's /check-in)

## Tone

Brief and mechanical. Resolve, cascade, report. This is bookkeeping that enables the next cycle, not a ceremony that slows it down.
