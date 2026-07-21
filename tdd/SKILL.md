---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
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

If scaffolding is missing, follow [ENGAGEMENT-REFERENCE.md](../ENGAGEMENT-REFERENCE.md).

Confirm the behavior list and interface design with the user before writing code.
Ask: "What should the public interface look like? Which behaviors are most important to test?"

### Phase 3 - Incremental loop

Show the user each test before writing implementation.
Do not block on their response - proceed with your ranking, but give the opportunity to redirect.

### Phase 4 - Refactor

See [tests.md](tests.md) for good/bad test examples, [mocking.md](mocking.md) for mocking guidelines,
[deep-modules.md](deep-modules.md) for interface depth, [interface-design.md](interface-design.md) for testability,
and [refactoring.md](refactoring.md) for refactor candidates.

## Per-cycle checklist

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
