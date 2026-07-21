# Requirements Protocol

Read `process/requirements.md` in full before starting.
It defines the complete methodology: scope, acceptance criteria, trade-offs, spec writing, artifact updates.
Follow it phase by phase.

## Context

If `SCOPE.md` exists, read it for project boundaries.
If `CONTEXT.md` exists, read it for domain terminology.
If `ARCHITECTURE.md` exists, read it for technical decisions.
Check `docs/specs/` for related specs.

## Rules

- Phase 1 (scope): print each question with your recommended answer.
  Let the user challenge and redirect. Do not ask open-ended questions.
- Phase 2 (acceptance criteria): write Given/When/Then for each in-scope behavior.
  Cover error states and edge cases. Explicitly state out-of-scope interactions.
- Phase 3 (trade-offs): when multiple valid approaches exist, present options
  with a recommendation. State what each option costs, not just what it does.
- Phase 4 (write the spec): output to `docs/specs/{feature-slug}.md`.
  A spec is a contract. Every sentence constrains scope or defines behavior.
  If a sentence does neither, cut it.
- Phase 5 (update artifacts): new domain terms to CONTEXT.md,
  architecture decisions to docs/adr/, open questions to docs/local/CONCERNS.md.
