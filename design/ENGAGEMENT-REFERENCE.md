# Engagement Reference

Design document for skill authors. Skills inline their own engagement rules.

How skills adapt to the user's current engagement level.
Model based on progressive engagement rather than missing scaffolding.
Skill authors read this when deciding how their skill should behave at each tier.

## Detection

On invocation, determine the engagement tier by reading project state:

| Signal | Tier |
|--------|------|
| No CONCERNS.md, no CLAUDE.md | Tier 1 - just working |
| CONCERNS.md exists (any content) | Tier 2 - tracking |
| CONCERNS.md exists + CLAUDE.md has Documentation Map | Tier 2+ (full cross-referencing) |
| Tier 2+ and user has opted into automatic concern emission | Tier 3 - automated |

Tier 3 is not detected from files alone.
It requires an explicit opt-in, stored in CLAUDE.md or `.claude/` settings:

```markdown
## Waypoint
concerns: auto-emit
```

Without that marker, always ask before emitting concerns (Tier 2 nudge behavior).

## Tier behaviors

### Tier 1 - Just working

The skill executes its full methodology.
No scaffolding files are expected.
No concern tracking is available.

**Adaptations:**
- Skip all cross-referencing (scope checks, convention enforcement, ADR verification).
- When the skill would normally cross-reference, substitute inline:
  - No CONTEXT.md -> define terms inline, don't link to a glossary.
  - No CONVENTIONS.md -> infer conventions from existing code, state what you inferred.
  - No SCOPE.md -> ask scope questions inline ("is this v1 or future?").
  - No TESTING.md -> state the default test philosophy, offer to adjust.
  - No docs/adr/ -> flag when a decision might reverse a past choice, note that no ADRs exist to check.
- State each adaptation once, in one sentence, then move on.

**Nudges at Tier 1:**

At the end of the skill's work, if the skill discovered something with cross-cutting impact, offer to start CONCERNS.md:

```
This debugging session revealed an undocumented business rule:
vessel status transitions require confirmation before committing.
This affects VesselCard, VesselList, and FixtureCard.

Want me to start a CONCERNS.md to track this? (One file, one entry. You can ignore it after this.)
```

The nudge follows the protocol: what was discovered, why it matters, ask once.
If the user declines, move on. Do not mention it again this session.

**First-invocation notice:**
On first-ever invocation in a project without scaffolding, show:

```
Tip: Waypoint skills work standalone. For convention enforcement
and cross-referencing, run /setup when you're ready.
```

Write `.claude/.setup-prompted` after showing this. Never show it again.

### Tier 2 - Tracking

CONCERNS.md exists. Skills read from it and write to it (with permission).

**Adaptations:**
- Read CONCERNS.md at session start. Note open concerns relevant to the current task.
- At the end of work, follow the nudge protocol for any discoveries.
- Emit concerns as `[open]` with type, raised date, and refs.
- Resolve concerns that are addressed by the current work (move to Resolved, add resolution note).
- When cross-referencing files exist (CONVENTIONS.md, SCOPE.md, etc.), use them. When they don't, use Tier 1 substitutions.

**Nudges at Tier 2:**

Two kinds of nudges become available:

1. **Concern emission** (same as Tier 1, but concerns are written to the file, not offered as a new file):
   ```
   This revealed that the mock API returns 200 for invalid entity IDs.
   The real API behavior is unknown. Added as C-039 [open].
   ```

2. **Deepening suggestions** (when the concern history shows a pattern):
   ```
   You have 8 open assumptions, 3 with medium risk and no deadline.
   /setup can run a structured validation pass if you want
   to stress-test these before they become real problems.
   ```

   Deepening suggestions appear at most once per session. They reference specific concern counts, not generic advice.

### Tier 3 - Automated

User has opted in to automatic concern emission.
Skills emit concerns without asking. The nudge protocol's "ask" step is skipped.

**Adaptations:**
- Emit concerns silently during work. Log what was emitted at the end of the session.
- Resolve concerns automatically when the skill's work directly addresses them.
- Surface only concerns that need human judgment (blocked, ambiguous, or high-risk).
- Offer automation suggestions when patterns emerge:
  ```
  You've resolved 4 spec-drift flags this week, all caught during /wrapup.
  A PostToolUse hook on Vue file edits could catch these at write time.
  Want me to add it?
  ```

**Automation suggestions:**

These are Tier 3-only. They require:
- A pattern of repeated manual work (at least 3 instances of the same concern type)
- A concrete automation proposal (hook, script, check), not vague advice
- User confirmation before implementing

## The nudge protocol

Every nudge, at every tier, follows three steps:

1. **What** - the specific discovery. Use concrete names, not abstractions.
   - Good: "Undocumented rule: vessel status requires confirmation before transition."
   - Bad: "Found an undocumented business rule."

2. **Why** - why it matters beyond this session. Reference scope, not theory.
   - Good: "This affects VesselCard, VesselList, and FixtureCard - all have status transitions."
   - Bad: "Undocumented rules can cause inconsistencies."

3. **Ask** - one question, one time.
   - Tier 1: "Want me to start CONCERNS.md to track this?"
   - Tier 2: "Added as C-039 [open]." (or "Want me to add this as a concern?")
   - Tier 3: Silent emission, logged at session end.

Never nag. If the user declines a nudge, do not re-offer the same concern.
If the user says "stop suggesting concerns," respect it for the rest of the session.

## Concern emission rules

### When to emit

Emit a concern when the skill discovers something that:
- Affects code or decisions beyond the current task (cross-cutting)
- Contradicts an existing assumption or spec (discrepancy)
- Cannot be fully resolved within the current skill invocation (deferred)
- Represents a risk that should be revisited later (time-bound)

### When NOT to emit

Do not emit a concern for:
- Things the skill just fixed (the fix is the resolution)
- Generic best practices ("you should add more tests")
- Things already tracked (check CONCERNS.md for duplicates first)
- Observations that only matter in the current context

### How to emit

```markdown
### C-{next_id} [open] {one-line description}
type: {question|assumption|flag} | raised: {today} | source: /{skill-name}
{1-3 lines of context}
refs: {paths to relevant files or other concern IDs}
```

Read the current max ID from CONCERNS.md and increment.
Place the new concern in the Open section.

## Scaffolding file table

When scaffolding files exist, skills gain capabilities.
When they don't, skills substitute (see Tier 1 adaptations).

| File | What it gives skills | Created by |
|------|---------------------|------------|
| CONCERNS.md | Concern tracking, cross-session continuity | Any skill (Tier 1 nudge) or /setup |
| CONTEXT.md | Term validation, glossary challenges | /grill-with-docs |
| CONVENTIONS.md | Naming enforcement | /setup |
| SCOPE.md | Scope boundary checks | /setup |
| TESTING.md | Project-specific test philosophy | /setup |
| ARCHITECTURE.md | Architecture cross-referencing | /setup |
| docs/adr/ | Decision history | /grill-with-docs |
| Documentation Map (in CLAUDE.md) | Indirection layer for all of the above | /setup |

Skills create only their own output artifacts.
/spec creates spec files, not SCOPE.md.
/diagnose creates fix files, not CONCERNS.md (but it nudges).

Exception: /grill-with-docs creates CONTEXT.md and docs/adr/ because those ARE its outputs.

## What skills should NOT do

- Don't block on missing scaffolding. Every skill works at Tier 1.
- Don't repeatedly mention what's missing. Adapt once, move on.
- Don't prompt for /setup more than once (marker file prevents this).
- Don't create scaffolding that belongs to another skill.
- Don't degrade silently. When you skip a check, say what you skipped and what you did instead, in one sentence.
- Don't nudge more than once per discovery. Ask, respect the answer.
- Don't emit concerns at Tier 2 without following the nudge protocol. The user chose to track - that doesn't mean they want every observation recorded.
- Don't offer automation suggestions below Tier 3. Premature automation is worse than manual work.
