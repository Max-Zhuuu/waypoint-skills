---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
status: stable
signals:
  - complete: suggests /wrapup
---

Does NOT skip tests. Red-green-refactor only.

Follow the TDD methodology in [process/tdd.md](../../process/tdd.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Plan

Read project context first: TESTING.md, CONVENTIONS.md, GLOSSARY.md.
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

## Tone

Disciplined. One test, one implementation, no shortcuts.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: issue)
Writes: none
Override: commit-producing skill - follows exit protocol (ENGAGEMENT-REFERENCE.md section 6)
## Exit

**Mid-cycle commits** (individual test passing, incremental refactor):
Auto-provisional. Emit issue concern silently. Commit with `[provisional]` marker.
No "stable or provisional?" question - asking on every commit in a 3-8 commit session trains reflexive dismissal.

**Natural boundary commits** (all slices for a feature complete, user signals "done"):
Ask: "All slices complete. Stable enough to document, or provisional?"
- Stable: run mini-wrapup (spec sync, term/pattern capture, concern resolution). Commit code + docs together.
- Provisional: emit issue concern with what needs documenting. Commit with `[provisional]` marker.
- Either way: "Next feature, or /wrapup?"

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) section 6 for the full exit protocol.

## Per-cycle checklist

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
