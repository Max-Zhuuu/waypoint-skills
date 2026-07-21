---
name: learn
description: Learning-oriented approach to any code task - new features, refactors, fixes, design patterns, architecture choices. Presents meaningfully different options with trade-off explanations and a terminology bridge. Use when you want to understand why one solution beats another.
status: stable
---

# Learn

Follow the structured learning methodology in [process/learning.md](../process/learning.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Scope

Read code context. Grep CONTEXT.md for domain terms relevant to this area.
If the task is trivial, say so and just do it - do not force options on a non-decision.

### Phase 2 - Present options

Use `AskUserQuestion` with `preview` on each option showing the actual code diff.
Mark the recommended option "(Recommended)" and list it first.

### Phase 3 - Bridge terminology

Include the Terms in play block and Further reading in the same response as the options.
For source trust tiers, see [REFERENCES.md](REFERENCES.md#source-trust-tiers).

### Phase 5 - Reinforce

Offer via `AskUserQuestion` with `multiSelect: true`: Quiz, Practice, or skip.
For quiz and practice protocols, see [LEARN-REFERENCE.md](LEARN-REFERENCE.md).

Skip when: the edit was trivial, the user is clearly in a hurry, or the concepts are ones they have demonstrated mastery of this session.

### Phase 6 - Learning notes

Save to `docs/local/learning/`. Create the directory if needed.
For format and rules, see [LEARN-REFERENCE.md](LEARN-REFERENCE.md#learning-notes).

## Engagement

On invocation, detect engagement tier:

| Signal | Tier |
|--------|------|
| No CONCERNS.md, no CLAUDE.md | Tier 1 - just working |
| CONCERNS.md exists | Tier 2 - tracking |
| CONCERNS.md + Documentation Map in CLAUDE.md | Tier 2+ |
| Tier 2+ and `concerns: auto-emit` in CLAUDE.md | Tier 3 - automated |

**Tier 1:** Execute the full methodology. Skip cross-referencing.
Substitute inline: no CONTEXT.md -> define terms inline; no CONVENTIONS.md -> infer from code;
no SCOPE.md -> ask scope inline; no TESTING.md -> state default philosophy.
State each adaptation once, then move on.

**Tier 2:** Read CONCERNS.md at start. Note relevant open concerns.
After work, follow the nudge protocol for discoveries. Emit as `[open]` with type, date, refs.

**Tier 3:** Emit concerns without asking. Log what was emitted at session end.

**Nudge protocol:**
1. **What** - the specific discovery, concrete names
2. **Why** - impact beyond this session
3. **Ask** - one question, one time. If declined, do not re-offer.

**Concern format:** `### C-{next_id} [open] {description}` / `type: {question|assumption|flag} | raised: {date} | source: /{skill-name}`

**Emit when:** cross-cutting, contradicts assumption, can't resolve now, time-bound risk.
**Don't emit:** things just fixed, generic advice, duplicates, current-context-only.

**Don't:** block on missing scaffolding; repeatedly mention what's missing; prompt for /setup more than once (`.claude/.setup-prompted`); create scaffolding owned by another skill; degrade silently.

## Tone

Keep it brisk. This is a 60-second decision point, not a lecture.
The user is mid-flow; get them back to building quickly.
