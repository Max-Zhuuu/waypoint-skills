---
name: check-in
description: Session authority. Reads concerns, proposes next task, fires checkpoints. The daily verb - use at every session start.
status: stable
disable-model-invocation: true
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
   - Flags first (implementation discrepancies need immediate resolution).
   - Questions with deadlines approaching or risk: high.
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

If CONCERNS.md doesn't exist, skip concern-based priority and fall to layer 2 (advance phase).

On invocation, detect engagement tier:

| Signal | Tier |
|--------|------|
| No CONCERNS.md, no CLAUDE.md | Tier 1 - just working |
| CONCERNS.md exists | Tier 2 - tracking |
| CONCERNS.md + Documentation Map in CLAUDE.md | Tier 2+ |
| Tier 2+ and `concerns: auto-emit` in CLAUDE.md | Tier 3 - automated |

Tier 3 requires explicit opt-in in CLAUDE.md:

```
## Waypoint
concerns: auto-emit
```

Without that marker, always ask before emitting concerns.

### Tier behaviors

**Tier 1:** Execute the full methodology. Skip cross-referencing.
Substitute inline: no CONTEXT.md -> define terms inline; no CONVENTIONS.md -> infer from code;
no SCOPE.md -> ask scope inline; no TESTING.md -> state default philosophy.
State each adaptation once, then move on.

First-invocation notice (if `.claude/.setup-prompted` doesn't exist):

```
Tip: Waypoint skills work standalone. For convention enforcement
and cross-referencing, run /setup when you're ready.
```

Write `.claude/.setup-prompted` after showing. Never show again.

**Tier 2:** Read CONCERNS.md at start. Categorize open concerns by type and age.
After work, follow the nudge protocol. Emit as `[open]` with type, date, refs.
Resolve concerns addressed by current work.

Deepening suggestions (at most once per session, when pattern emerges):

```
You have 8 open assumptions, 3 with medium risk and no deadline.
/setup can run a structured validation pass if you want
to stress-test these before they become real problems.
```

**Tier 3:** Emit concerns without asking. Log emissions at session end.
Resolve automatically when work addresses them.
Surface only concerns needing human judgment.

Automation suggestions (Tier 3 only, requires 3+ instances of same concern type):

```
You've resolved 4 spec-drift flags this week, all caught during /wrapup.
A PostToolUse hook could catch these at write time. Want me to add it?
```

### Nudge protocol

1. **What** - specific discovery, concrete names
2. **Why** - impact beyond this session
3. **Ask** - one question, one time. If declined, do not re-offer.

### Concern emission

**Format:** `### C-{next_id} [open] {description}` / `type: {question|assumption|flag} | raised: {date} | source: /{skill-name}`

**Emit when:** cross-cutting, contradicts assumption, can't resolve now, time-bound risk.
**Don't emit:** things just fixed, generic advice, duplicates, current-context-only.

### Scaffolding file table

| File | What it gives skills | Created by |
|------|---------------------|------------|
| CONCERNS.md | Concern tracking, cross-session continuity | Any skill (Tier 1 nudge) or /setup |
| CONTEXT.md | Term validation, glossary challenges | /grill-with-docs |
| CONVENTIONS.md | Naming enforcement | /setup |
| SCOPE.md | Scope boundary checks | /setup |
| TESTING.md | Project-specific test philosophy | /setup |
| ARCHITECTURE.md | Architecture cross-referencing | /setup |
| docs/adr/ | Decision history | /grill-with-docs |
| Documentation Map (in CLAUDE.md) | Indirection layer | /setup |

### Prohibitions

- Don't block on missing scaffolding
- Don't repeatedly mention what's missing
- Don't prompt for /setup more than once (`.claude/.setup-prompted`)
- Don't create scaffolding owned by another skill
- Don't degrade silently - state what you skipped, once
- Don't nudge more than once per discovery
- Don't emit at Tier 2 without the nudge protocol
- Don't offer automation suggestions below Tier 3

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
