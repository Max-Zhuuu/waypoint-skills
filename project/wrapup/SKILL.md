---
name: wrapup
description: Completion verb. Resolves concerns from implementation, cascades to shared docs, evaluates gate criteria. Run after /port or /tdd.
status: stable
disable-model-invocation: true
inputs:
  concerns: CONCERNS.md entries referencing the current entity
outputs:
  concerns-resolved: CONCERNS.md entries marked resolved with decision lines
  shared-docs: CONVENTIONS.md, CONTEXT.md, DESIGN-SYSTEM.md updated if cascade needed
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

Any mismatch becomes a new concern in CONCERNS.md (type: flag, source: /wrapup).

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
- New domain term resolved -> CONTEXT.md
- New token or design pattern -> DESIGN-SYSTEM.md (if exists)
- Spec structure change -> flag for template review
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

If CONCERNS.md doesn't exist, /wrapup creates it with the resolved entries from this run.
Cascade to shared docs (step 4) only fires for docs that exist.

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

## Tone

Brief and mechanical. Resolve, cascade, report. This is bookkeeping that enables the next cycle, not a ceremony that slows it down.
