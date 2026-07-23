---
name: check-in
description: Session authority. Reads concerns, proposes next task, fires checkpoints. The daily verb - use at every session start.
status: stable
inputs: {}
outputs: {}
signals:
  proposes: implementation verb (/port, /tdd, or user-chosen methodology)
---

# Check-in

The session authority. Run this every time you sit down to work.
Reads project state, proposes what to do next, fires pre-build checkpoints.

Does NOT implement. Does NOT update docs (that's /wrapup). Proposes work, then asks the user which implementation verb to invoke.

## On invocation

1. Read `## Active Workflow` from CLAUDE.md. This tells you the active skill, current phase, and activation date.
2. If no workflow record: detect project type from SCOPE.md frontmatter. Recommend /migrate, /buildout, or /create.
3. Read CONCERNS.md (if it exists). Categorize open concerns by type and age.
4. Read the current phase file from the workflow skill's folder.
5. Apply priority stack to propose next task.

Print:

```
Phase {N} ({name}). {X} items remaining.
{open concerns summary - count by type, anything critical}
Next: {proposed task} - {why this one}.
```

## Authority model

/check-in is the authority, not a dispatcher.
Phase files define *what* to check. /check-in decides *when and how* to act.

Enforcement violations surface in the report as context.
The priority stack still proposes work, including resolution of violations.
A violation never creates a deadlock. If enforcement says "spec missing" and the stack says "build next entity," /check-in proposes: "Write the spec first, then build."

## Task proposal - priority stack

Three layers, checked in order. Propose the first match:

1. **Resolve open concerns.** Read CONCERNS.md open section.
   - Issues first (implementation discrepancies need immediate resolution).
   - Questions with validate-by dates approaching or risk: high.
   - Milestones: check which specs are complete, propose next work toward the nearest open milestone.
   - Stale claims (>4 hours) signal interrupted work - propose resuming.
   - If a concern references an entity: propose "/wrapup on {entity}."
   - If a concern has no entity reference: propose direct resolution.

2. **Advance phase.** Pick the next item from the current phase's work list.
   Order by dependency (parents before children), then risk (uncertain before routine).

3. **Gate check.** If all phase work is done, evaluate gate criteria.
   If met, prompt to advance. If not, show specific remaining items.

## Methodology selection

When proposing implementation work, ask the user which verb to invoke via AskUserQuestion:

- For migration screens: /port (default)
- For new features: /tdd (default)
- For design work: /design or user's chosen methodology

The process layer does not hardcode which methodology skill to use.

## Pre-build checkpoint

Fires before the user starts implementation. Validates the verb's declared inputs exist.

If a required input is missing:
- Missing spec + source system exists: "Write the spec first."
- Missing spec + no source: "Invoke /spec to grill requirements."

## Phase regression

When a gate can't pass because an earlier-phase decision is invalidated:

1. Recognize this as regression, not leapfrogging.
2. Propose: "Phase {N} gate blocked - {decision} invalidated by {evidence}. Regressing to Phase {M}."
3. Tracked via: ADR (rationale) + inventory reversion (state) + git history (timeline).
4. On resolution, /check-in re-proposes the original phase work naturally.

## Enforcement

### Core rules (always fire)

1. Specs exist before implementation begins
2. No phase leapfrogging (unless regression)
3. No stale critical concerns (flags or high-risk assumptions past deadline)

### Archetype extras (composable, multi-select)

Selected archetypes in SCOPE.md add enforcement rules to the core set.
If no archetypes selected: core rules only + dynamic adaptation.

## Engagement

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.

- **Emits:** flags, session plan, priority recommendations
- **Scaffolding writes:** writes `.claude/.setup-prompted` on first Tier 1 invocation
- **Override:** at Tier 1 without CONCERNS.md, skips concern-based priority and falls to phase-advance layer. Does not create CONCERNS.md - that's /reorient's or /wrapup's job.
- **Nudge protocol:** detect tier -> suggest setup/upgrade once -> back off if declined
- **Concern format:** `### C-NNN [open] <summary>` with type, raised date, source skill
- **Prohibitions:** no file creation outside owned paths, no silent scaffolding, no tier-skipping
- **Before writing** to shared-append or owned files, check Claims in CONCERNS.md

Provisional-doc pressure: surfaces issue concerns from provisional commits grouped by feature, with age-based escalation (see ENGAGEMENT-REFERENCE.md section 6).
Stale claims: warns about Claims older than 4 hours at session start.

## Dynamic adaptation

/check-in adapts ceremony to observed complexity:
- Few entities, simple specs -> lighter ceremony
- Many entities, complex interdependencies -> more structure
- Repeated concerns of the same type -> suggest /reorient

## Concurrent sessions

When claims in CONCERNS.md show multiple active sessions:
- Propose work in unclaimed file areas.
- If claims overlap, suggest resolving the overlap first.
- Stale claims (>4 hours) are noted but not auto-removed.

```
{N} concurrent sessions active. Proposing work in unclaimed areas.
```

## Conditional invocations

- **Invoke /reorient** when drift detected: same phase 2+ weeks, accumulating concerns, stale entries.
- /reorient output feeds back into the priority stack.

## Tone

Brief. Read state, propose work, move on.
