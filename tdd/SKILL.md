---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
status: stable
signals:
  - complete: suggests /wrapup
---

# Test-Driven Development

Follow the TDD methodology in [process/tdd.md](../process/tdd.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Plan

Read project context first: TESTING.md, CONVENTIONS.md, CONTEXT.md.
Check the project's domain glossary so test names match project language.
Check ADRs in the area you are touching.

Confirm the behavior list and interface design with the user before writing code.
Ask: "What should the public interface look like? Which behaviors are most important to test?"

### Phase 3 - Incremental loop

Show the user each test before writing implementation.
Do not block on their response - proceed with your ranking, but give the opportunity to redirect.

### Phase 4 - Refactor

See [tests.md](tests.md) for good/bad test examples, [mocking.md](mocking.md) for mocking guidelines,
[deep-modules.md](deep-modules.md) for interface depth, [interface-design.md](interface-design.md) for testability,
and [refactoring.md](refactoring.md) for refactor candidates.

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

## Per-cycle checklist

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
