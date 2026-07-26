---
name: wrapup
description: "Resolve concerns, cascade to shared docs, evaluate gate criteria. Run after /port or /tdd."
status: stable
inputs:
  concerns: CONCERNS.md entries referencing the current entity
outputs:
  concerns-resolved: CONCERNS.md entries marked resolved with decision lines
  shared-docs: CONVENTIONS.md, GLOSSARY.md, DESIGN-SYSTEM.md updated if cascade needed
  inventory: marker confirmed or advanced
  blocking-verdict: open blocking concerns for the change, or "none" - the authored value /ship consumes for afk gate key 1b
signals: []
---

The completion verb. Single reconciliation point for all doc updates after implementation.

- Invoke after /port or /tdd reports complete (suggested by the verb).
- Optional: skip if confident. Unresolved concerns persist in CONCERNS.md.
- If skipped: /check-in surfaces them next session as priority work.

## Process

### 1. Gather concerns

Read CONCERNS.md. Filter open concerns that reference the current entity (by `refs:` field or entity name in the description).
Also include any concerns emitted by the implementation verb this session.

### 2. Spec drift check

Re-read the entity's documentation and compare against what was built.
This catches discrepancies the implementation verb didn't flag - a documentation safety net, not a code review.
Follow the field-by-field checklist in [reference/spec-drift-checklist.md](reference/spec-drift-checklist.md) for both the feature spec and the logic doc.
Any mismatch becomes a new concern in CONCERNS.md (type: issue, source: /wrapup).
If no feature spec or logic doc exists: report "No {doc type} found. Drift check skipped." and continue - do not block.

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
Recalculate the summary header after all resolutions.
For milestone-type concerns, follow [reference/milestone-closure.md](reference/milestone-closure.md) to offer spec archival.

### 4. Cascade to shared docs

Check whether any resolution affects shared docs, cascading per [reference/cascade-rules.md](reference/cascade-rules.md).
Only cascade for genuine shared-doc changes, not entity-local updates.

### 5. Archive resolved concerns

Count the entries in the Resolved section and archive per [reference/archive-procedure.md](reference/archive-procedure.md) if the threshold is exceeded.

### 6. Evaluate gate

Check the current phase's gate criteria:
- How many items remain at current phase?
- Are all gate conditions for completed items satisfied?
- Are there blocking concerns? This verdict is authoritative: /ship consumes the `Blocking:` line below for the afk gate (key 1b) and never re-derives "blocking" from raw CONCERNS.md.

Report:

```
Wrapup complete. {entity}: {N} concerns resolved, {M} escalated.
{if archived} Archived {K} resolved concerns to concerns/resolved-{YYYY}.md.
Blocking: {none | C-041, C-047}.
Gate: {X}/{Y} criteria met. Remaining: {list}.
```

## Exit

- /review for a critic pass before shipping - and on a local project with no pipeline, it is your only conformance check. wrapup suggests, never reviews.
- /ship to deliver this change, if DEPLOY.md names a remote adapter.
- /check-in for next session.
- On exit, emit the artifacts manifest for the paths this run wrote, per [ENGAGEMENT-REFERENCE.md section 15](../../internals/ENGAGEMENT-REFERENCE.md); a run that wrote nothing prints the empty manifest.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: issues, resolution notes, consolidated audit results
Writes: creates CONCERNS.md if absent (seeded with this run's resolved entries)
Override: Cascade step only fires for docs that exist - does not create docs to cascade into.
## Tone

Brief and mechanical. Resolve, cascade, report. This is bookkeeping that enables the next cycle, not a ceremony that slows it down.
