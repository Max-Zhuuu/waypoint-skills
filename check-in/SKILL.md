---
name: check-in
description: Session authority. Detects project type and phase, proposes next task, fires checkpoints. The daily verb - use at every session start.
disable-model-invocation: true
inputs: {}
outputs: {}
signals:
  proposes: implementation verb (/port, /tdd, or user-chosen methodology)
---

# Check-in

The session authority. Run this every time you sit down to work.
Detects where you are, makes the call on what's next, fires pre-build checkpoints.

Does NOT implement. Does NOT update docs (that's /wrapup). Proposes work, then asks the user which implementation verb to invoke.

## On invocation

1. Read `## Active Workflow` section from CLAUDE.md. This tells you the active skill (/migrate, /buildout, or /create), current phase, and activation date.
2. If no workflow record exists: detect project type from SCOPE.md frontmatter (archetype markers, parity-strategy). Recommend the user run /migrate, /buildout, or /create to set one.
3. Read the current phase file (from the workflow skill's folder). For /create, there are no phase files - just check for pending specs and unresolved flags.
4. Collect enforcement inputs from the workflow skill's SKILL.md.
5. Check for unresolved ## Flags sections in feature specs (deferred /wrapup work).
6. Apply priority stack to propose next task.
7. Report state, then propose.

Print:

```
Phase {N} ({name}). {X} items remaining.
{violations/flags if any - as context, not blockers}
Next: {proposed task} - {why this one}.
```

## Authority model

/check-in is the authority, not a dispatcher. Phase files define *what* to check (enforcement rules). /check-in decides *when and how* to act.

- Enforcement violations surface in the report as context.
- The priority stack still proposes work - including the *resolution* of violations.
- A violation never creates a deadlock. If enforcement says "spec missing" and the priority stack says "build next entity," /check-in proposes: "Write the spec first, then build."

## Task proposal - priority stack

Five layers, checked in order. Propose the first match:

1. **Resolve deferred /wrapup work.** Check feature specs for ## Flags sections from previous sessions. Propose "/wrapup on {entity}" if flags exist.
2. **Resume interrupted work.** Check ACTIVE-WORK.md (if exists) and git history for uncommitted or in-progress items.
3. **Resolve blockers.** Check QUESTIONS.md (if exists) for critical items. Check ASSUMPTIONS.md (if exists) for overdue items. Check handoffs/ (if exists) for delivered items needing integration.
4. **Advance phase.** Pick the next item from the current phase's work list. Order by dependency (parents before children), then by risk (uncertain before routine).
5. **Gate check.** If all phase work is done, evaluate gate criteria. If met, prompt to advance. If not, show specific remaining items.

## Methodology selection

When proposing implementation work, ask the user which verb to invoke via AskUserQuestion:

- For migration screens: /port (default), or user's chosen alternative
- For new features: /tdd (default), or user's chosen alternative
- For design work: /design or user's chosen methodology skill

The process layer does not hardcode which methodology skill to use.

## Pre-build checkpoint

Fires before the user starts implementation. Validates the verb's declared inputs exist:

- Read the verb's frontmatter contract (inputs section).
- Validate each required file exists.
- Report what's missing and what to do.

If a required input is missing:
- Missing spec + source system exists: "Leaked earlier-phase work. Write the spec first."
- Missing spec + no source: "Invoke /spec to grill requirements."

## Phase regression

When a gate can't pass because an earlier-phase decision is invalidated:

1. Recognize this as regression, not leapfrogging.
2. Propose: "Phase {N} gate blocked - {ADR/decision} invalidated by {evidence}. Regressing to Phase {M} to resolve."
3. The regression is tracked via: ADR (rationale) + inventory reversion (state) + git history (timeline).
4. No separate artifact. No timestamp log.
5. On resolution, /check-in re-proposes the original phase work naturally.

## Enforcement

### Core rules (always fire)

1. Specs exist before implementation begins
2. No phase leapfrogging (unless regression - see above)
3. No stale critical blockers (QUESTIONS.md items if file exists)

### Archetype extras (composable, multi-select)

Selected archetypes in SCOPE.md frontmatter add enforcement rules to the core set.
If no archetypes selected: core rules only + dynamic adaptation.

### Graceful degradation

If a file referenced by an enforcement rule doesn't exist (docs/local/ is personal, ephemeral):
- That rule doesn't fire.
- No false violations from missing personal files.
- /check-in never errors on missing optional state.

When a missing file would be useful for the current workflow phase (e.g., QUESTIONS.md during integration work), mention it once in the report as awareness: "QUESTIONS.md doesn't exist yet - will be created when unknowns surface." Not a blocker, not repeated.

See [project-setup/LOCAL-DOCS-REFERENCE.md](../project-setup/LOCAL-DOCS-REFERENCE.md) for the canonical file list and lazy creation rule.

## Dynamic adaptation

/check-in adapts ceremony to observed complexity rather than rigidly following the archetype:
- Few entities, simple specs -> lighter ceremony (skip verbose reporting)
- Many entities, complex interdependencies -> more structure (explicit dependency ordering)
- Repeated violations of the same type -> suggest /reorient

The archetype sets the starting ceremony level. Reality adjusts it.

## Conditional invocations

- **Invoke /reorient** when drift detected: same phase 2+ weeks, accumulating violations, stale questions.
- **/reorient** output feeds back into the task proposal stack.

## Resolution cascade

When a checkpoint finds a mismatch (spec vs code, spec vs API, spec vs source), apply the resolution cascade (see README.md > Key Concepts > Resolution Cascade). Never skip to human validation without trying the first two steps.
