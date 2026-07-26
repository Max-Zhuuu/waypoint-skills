---
name: tdd
description: "Build features or fix bugs with red-green-refactor. Test-first, behavior-driven, no shortcuts."
status: stable
signals:
  - complete: suggests /wrapup
---

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

See [tests.md](reference/tests.md) for good/bad test examples, [mocking.md](reference/mocking.md) for mocking guidelines,
[deep-modules.md](reference/deep-modules.md) for interface depth, [interface-design.md](reference/interface-design.md) for testability,
and [refactoring.md](reference/refactoring.md) for refactor candidates.

## Tone

Disciplined. One test, one implementation, no shortcuts.

Does NOT skip tests. Red-green-refactor only.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: concerns (type: issue)
Writes: a per-slice done marker (structural, in trusted config) on completing a slice (reference/slice-marker.md)
Override: commit-producing skill - follows exit protocol (engagement/README.md section 6)
## Exit

**Mid-cycle commits** (individual test passing, incremental refactor):
Auto-provisional. Emit issue concern silently. Commit with `[provisional]` marker.
No "stable or provisional?" question - asking on every commit in a 3-8 commit session trains reflexive dismissal.

**Natural boundary commits** (all slices for a feature complete, user signals "done"):
Ask: "All slices complete. Stable enough to document, or provisional?"
- Stable: run mini-wrapup (spec sync, term/pattern capture, concern resolution). Commit code + docs together.
- Provisional: emit issue concern with what needs documenting. Commit with `[provisional]` marker.
- Either way: "Next feature, or /wrapup?"

**On completing a slice** (its Done-when met, tests green): write the per-slice done marker ([reference/slice-marker.md](reference/slice-marker.md)), keyed by (project identity, slice id). This is the structural completion signal the chain reads to derive `REM` (remaining = defined minus marked); it is bookkeeping, not a position pointer, and an absent or unresolvable marker reads as remaining, never as done.

See [the engagement protocol](../../internals/engagement/README.md) section 6 for the full exit protocol.
- On exit, emit the artifacts manifest for the paths this run wrote, per [the artifacts manifest](../../internals/engagement/manifest.md); a run that wrote nothing prints the empty manifest.
- On exit, after the manifest, run the chain dispatcher for the next hop, per [the chain dispatcher](../../internals/chain/reference.md); a gate (or no clean edge) stops and hands back.

## Per-cycle checklist

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
