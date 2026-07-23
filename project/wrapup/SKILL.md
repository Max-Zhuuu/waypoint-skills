---
name: wrapup
description: Completion verb. Resolves concerns from implementation, cascades to shared docs, evaluates gate criteria. Run after /port or /tdd.
status: stable
inputs:
  concerns: CONCERNS.md entries referencing the current entity
outputs:
  concerns-resolved: CONCERNS.md entries marked resolved with decision lines
  shared-docs: CONVENTIONS.md, GLOSSARY.md, DESIGN-SYSTEM.md updated if cascade needed
  inventory: marker confirmed or advanced
signals: []
---

# Wrapup

The completion verb. Single reconciliation point for all doc updates after implementation.

## Role

/wrapup resolves concerns raised during implementation, cascades changes to shared docs, and evaluates gate criteria.
It is the only skill that writes to shared docs after implementation.

## When to invoke

- After /port or /tdd reports complete (suggested by the verb)
- Optional: skip if confident. Unresolved concerns persist in CONCERNS.md.
- If skipped: /check-in surfaces them next session as priority work.

## Process

### 1. Gather concerns

Read CONCERNS.md. Filter open concerns that reference the current entity (by `refs:` field or entity name in the description).
Also include any concerns emitted by the implementation verb this session.

### 2. Spec drift check

Re-read the entity's documentation and compare against what was built.
This catches discrepancies the implementation verb didn't flag - a documentation safety net, not a code review.

**Feature spec** - check these sections against the built component:
- Fields & Controls: is every declared field present? Any undeclared fields added?
- Interaction Behaviors: do sortable/filterable/resizable declarations match?
- Conditional Visibility: do show/hide rules match?
- Navigation: do declared routes and links exist?

**Logic doc** - check these sections against the built code:
- Data Model: do field names, types, and nullability match?
- Relationships: are declared entity references present?
- Status Lifecycle: do transitions match?
- Business Rules: are declared rules enforced?

Any mismatch becomes a new concern in CONCERNS.md (type: issue, source: /wrapup).

If no feature spec or logic doc exists: "No {doc type} found. Drift check skipped." Continue.
Do not block - this preserves /wrapup's lightweight contract for task-layer usage.

### 3. Resolve each concern

Apply the resolution cascade:

1. **Read the authoritative source for ground truth.**
   Example: spec says 12 fields, source system screen shows 14.
2. **Write or run a test that proves which side is correct.**
   If test passes, spec is outdated. If test fails, source doc is wrong.
3. **Escalate to the user with specifics if source and tests are ambiguous.**
   Present the concrete mismatch, not a vague question.

Never skip to step 3 without trying steps 1 and 2.

Resolution outcomes:
- **Spec was wrong** - update the spec, add Change Log entry
- **Build was wrong** - fix the code (or note as follow-up)
- **Both need updating** - update spec, fix code
- **Intentional difference** - document in spec Change Log with rationale

Mark each resolved concern in CONCERNS.md: change status to `[resolved]`, add `resolved:` date and `decision:` line, move to the Resolved section.

### 4. Cascade to shared docs

Check whether any resolution affects shared docs:
- New naming pattern emerged -> CONVENTIONS.md
- New domain term resolved -> GLOSSARY.md
- New token or design pattern -> DESIGN-SYSTEM.md (if exists)
- Spec structure change -> issue for template review
- Spec fully superseded -> move old to docs/local/archive/

Only cascade for genuine shared-doc changes, not entity-local updates.

### 5. Evaluate gate

Check the current phase's gate criteria:
- How many items remain at current phase?
- Are all gate conditions for completed items satisfied?
- Are there blocking concerns?

Report:

```
Wrapup complete. {entity}: {N} concerns resolved, {M} escalated.
Gate: {X}/{Y} criteria met. Remaining: {list}.
```

## What /wrapup does NOT do

- Propose next work (that's /check-in)
- Implement features (that's the implementation verb)
- Make architectural decisions (that's /grill-with-docs)

## Engagement

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.

- **Emits:** flags, resolution notes, consolidated audit results
- **Scaffolding writes:** creates CONCERNS.md if absent (seeded with this run's resolved entries)
- **Override:** CONCERNS.md auto-creation at Tier 1. Cascade step only fires for docs that exist - does not create docs to cascade into.
- **Nudge protocol:** detect tier -> suggest setup/upgrade once -> back off if declined
- **Concern format:** `### C-NNN [open] <summary>` with type, raised date, source skill
- **Prohibitions:** no file creation outside owned paths (except CONCERNS.md), no silent scaffolding, no tier-skipping
- **Before writing** to shared-append or owned files, check Claims in CONCERNS.md

## Tone

Brief and mechanical. Resolve, cascade, report. This is bookkeeping that enables the next cycle, not a ceremony that slows it down.
