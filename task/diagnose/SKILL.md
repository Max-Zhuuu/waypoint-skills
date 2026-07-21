---
name: diagnose
description: Disciplined diagnosis loop for hard bugs and performance regressions. Reproduce, minimise, hypothesise, instrument, fix, regression-test. Use when user says "diagnose this" / "debug this", reports a bug, says something is broken/throwing/failing, or describes a performance regression.
status: stable
---

# Diagnose

Follow the debugging methodology in [process/debugging.md](../../process/debugging.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Feedback loop

Use project tools to build the loop:
- Bash/PowerShell for test runners, curl scripts, CLI invocations
- chrome-devtools-axi for browser-based reproduction
- The project's test framework for failing-test loops

If the project has a domain glossary (check Documentation Map or CONTEXT.md), read it before exploring the codebase.
If ADRs exist, check the ones in the area you are touching.

### Phase 3 - Hypotheses

Show the ranked list to the user before testing.
Do not block on their response - proceed with your ranking if they are not available, but give them the opportunity to re-rank.

### Phase 4 - Instrumentation

Use the `[DEBUG-xxxx]` tagging convention from the methodology.
Grep for your tag prefix during Phase 6 cleanup.

### Phase 5 - Fix

For the regression test seam assessment: if no correct seam exists and the architecture is preventing the bug from being locked down, hand off to `/improve-codebase-architecture` with the specifics after the fix is in.

### Phase 7 - Learn

Follow the quiz and practice protocols in [learn/LEARN-REFERENCE.md](../../task/learn/LEARN-REFERENCE.md) if the user opts in.
Update CONTEXT.md with domain terms only (not general programming concepts).
Link further-reading sources per [learn/REFERENCES.md](../../task/learn/REFERENCES.md#source-trust-tiers).

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
