---
name: check-in
description: Session authority. Reads concerns, proposes next task, fires checkpoints. The daily verb - use at every session start.
status: stable
inputs: {}
outputs: {}
signals:
  proposes: implementation verb (/port, /tdd, or user-chosen methodology)
---

1. Read `## Active Workflow` from CLAUDE.md. This tells you the active skill, current phase, and activation date.
2. If no workflow record: detect project type from SCOPE.md frontmatter. Recommend /migrate, /buildout, or /create.
3. Read CONCERNS.md (if it exists):
   - Parse the summary header (line 2) for counts and `@L` offsets.
   - Read Claims section (always).
   - Read Open, Investigating, and Blocked sections using `@L` offsets. Skip Resolved.
   - If the hook already injected these sections, skip the disk read.
4. Read the current phase file from the workflow skill's folder.
5. Read [reference/priority-stack.md](reference/priority-stack.md) and apply the priority stack to propose next task.
6. Surface the downstream view (read-only) per [reference/downstream-view.md](reference/downstream-view.md): what `/ship` staged but nobody promoted, and what the pipeline is blocking. Link, category, and status only; never act on it, never pull its text back.

Print:

```
Phase {N} ({name}). {X} items remaining.
{open concerns summary - count by type, anything critical}
{downstream: staged-not-promoted and blocked PRs, each a link + category + status; "downstream status unavailable" if the query could not run; omit if no DEPLOY.md}
Next: {proposed task} - {why this one}.
```

## Authority model

/check-in is the authority, not a dispatcher.
Phase files define *what* to check. /check-in decides *when and how* to act.

Enforcement violations surface in the report as context.
The priority stack still proposes work, including resolution of violations.
A violation never creates a deadlock. If enforcement says "spec missing" and the stack says "build next entity," /check-in proposes: "Write the spec first, then build."

## Pre-build checkpoint

Fires before the user starts implementation. Validates the verb's declared inputs exist.

If a required input is missing:
- Missing spec + source system exists: "Write the spec first."
- Missing spec + no source: "Invoke /spec to grill requirements."

Read [reference/enforcement.md](reference/enforcement.md) for the enforcement rules (core + archetype extras), phase regression handling, dynamic ceremony adaptation, and concurrent-session behavior. These are conditional - apply them when the triggering condition is observed, not on every invocation.

## Exit

- Invokes the chosen implementation skill (/port, /create, /tdd).
- Session continues under the invoked skill.

Does NOT implement. Does NOT update docs (that is /wrapup). Does NOT promote (no promote verb exists; promotion is human-owned) or pull downstream text into the repo. Proposes work, then asks which verb to invoke.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: flags, session plan, priority recommendations
Writes: writes `.claude/.setup-prompted` on first Tier 1 invocation
Override: at Tier 1 without CONCERNS.md, skips concern-based priority and falls to phase-advance layer.

## Conditional invocations

- **Invoke /reorient** when drift detected: same phase 2+ weeks, accumulating concerns, stale entries.
- /reorient output feeds back into the priority stack.

## Tone

Brief. Read state, propose work, move on.
