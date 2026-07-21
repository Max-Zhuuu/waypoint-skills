---
name: spec
description: Feature-level requirements skill. Grills on scope and acceptance criteria, outputs a spec file. Use when starting a new feature, when requirements are vague, or when the user says "spec this", "write a spec", "PRD".
status: stable
---

# Spec

Follow the requirements methodology in [process/requirements.md](../process/requirements.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Scope

Read any existing context first: SCOPE.md, CONTEXT.md, ARCHITECTURE.md, related specs in `docs/specs/`.

Grill inline. Print questions with your recommended answer so the user can challenge.
Do not use `AskUserQuestion` for the grilling loop - inline conversation lets the user redirect naturally.

### Phase 2 - Acceptance criteria

Present options where trade-offs exist, per the methodology.
Mark the recommendation and state why. The user picks or challenges.

### Phase 3 - Write the spec

Output to `docs/specs/{feature-slug}.md` using the template from the methodology.

### Phase 4 - Update shared artifacts

1. New domain terms -> update CONTEXT.md (domain terms only, not general programming concepts).
2. Architecture decision -> suggest invoking `/grill-with-docs` for an ADR.
3. Feature tracked in an inventory or roadmap -> add it.

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

Concise. A spec is a contract, not a narrative.
Every sentence should either constrain scope or define behavior.
If a sentence does neither, cut it.
