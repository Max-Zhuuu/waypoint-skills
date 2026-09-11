---
name: tdd
description: "Build features or fix bugs with red-green-refactor. Test-first, behavior-driven, no shortcuts."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Process methodology: [process/tdd.md](../../process/tdd.md).

Does NOT skip tests. Red-green-refactor only.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: issue)
Writes: per-slice done marker (trusted config)
Override: commit-producing skill

## Exit
- /review for a critic pass.
- /wrapup to resolve concerns and cascade docs.

## Tone
Disciplined. One test, one implementation, no shortcuts.
