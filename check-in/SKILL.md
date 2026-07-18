---
name: check-in
description: Session orchestrator. Detects project type and phase, proposes next task, fires checkpoints, updates inventory. The daily verb - use at every session start.
disable-model-invocation: true
---

# Check-in

The session verb. Run this every time you sit down to work.
Detects where you are, proposes what's next, fires checkpoints during and after work.

Does NOT implement. Proposes work, then the user invokes `/tdd` (greenfield) or `/port` (migration) to build.

## On invocation

1. Detect project type: look for `/migrate` or `/buildout` setup markers in SCOPE.md.
2. Detect current phase from inventory markers, docs, git history.
3. Read the current phase file (from the appropriate skill folder).
4. Run enforcement checks from the project's SKILL.md (migrate or buildout).
5. Propose next task using the priority stack (below).
6. Report violations before proposing work.

Print:

```
Phase {N} ({name}). {X} items remaining.
Next: {proposed task} - {why this one}.
{violations if any}
```

## Task proposal - priority stack

Four layers, checked in order. Propose the first match:

1. **Resume interrupted work.** Check ACTIVE-WORK.md and git history for uncommitted or in-progress items from previous sessions.
2. **Resolve blockers.** Check QUESTIONS.md for critical items. Check ASSUMPTIONS.md for overdue items. Check handoffs/ for items with status: delivered that need integration.
3. **Advance phase.** Pick the next item from the current phase's work list. Order by dependency (parents before children), then by risk (uncertain before routine).
4. **Gate check.** If all phase work is done, evaluate gate criteria. If met, prompt to advance. If not, show specific blockers.

## Checkpoint execution

Read checkpoints from the current phase file (they appear at the top in CP1/CP2 format).

### Pre-build checkpoint

Fires before the user starts implementation. Reads the checkpoint's References list, validates each file exists and is current, and reports the result.

If the checkpoint blocks (e.g., no spec exists), report what's missing and what to do:
- Missing spec + source system exists: "This is leaked Phase 2 work. Write the spec first."
- Missing spec + no source system: "Invoke /spec to grill requirements."

### Post-build checkpoint

Fires when the user reports work complete. Spawns a review agent, runs doc sync, updates inventory.

**Review agent allocation** (derived from spec content, not judgment):
- **Moderate** (5:1 ratio, Sonnet reviewer): no conditional visibility 3+ rules, no status lifecycle in logic doc, fewer than 4 tabs.
- **High** (3:1 ratio, Opus reviewer): conditional visibility 3+ rules, OR status lifecycle, OR 4+ tabs.

**Doc sync** (required action within post-build):
1. Diff the build against its reference list. List any field, behavior, or pattern that differs from the spec.
2. Mechanical diffs (field renamed, order changed): update the spec inline.
3. Intentional deviations: flag for human review, append to spec's Change Log.
4. Cascade check: did this build change anything that affects shared docs?
   - New naming pattern -> update CONVENTIONS.md
   - New token introduced -> update DESIGN-SYSTEM.md
   - New domain term resolved -> update CONTEXT.md
5. Pass condition: review passed AND spec matches build AND shared docs are current.

## Phase-specific behavior

### During build phases (3-5 migrate, 3-4 buildout)

Propose from inventory. Task-level granularity: "VesselParticulars is next - 3 dependents waiting on it."

### During 6b-i (Design System)

Propose from TOKEN-AUDIT.md gap list. Systematic: "3 token gaps in Feedback category. Next: define --toast-elevation and --toast-duration."

### During 6b-ii (UX Improvements)

Phase-level guidance. Designer-directed: "You're in 6b-ii macro. 2 page-level improvements remaining. navigation-tab-personalization - research checkpoint not complete."

Do NOT propose design tasks during build phases. Design exploration during builds is unmanaged (D42).

## Conditional invocations

- **Invoke /reorient** when drift detected: same phase 2+ weeks, accumulating violations, stale questions piling up.
- **/reorient**'s PROGRESS-AUDIT.md feeds back into the task proposal stack.

## Resolution cascade

When a checkpoint finds a mismatch (spec vs code, spec vs API, spec vs source):

1. **Source code validation** - read the authoritative source for ground truth.
2. **Test case validation** - write or run a test that proves which side is correct.
3. **Human validation** - escalate with specifics if source and tests are ambiguous.

Never skip to human validation without trying the first two.
