---
name: diagnose
description: "Run a disciplined diagnosis loop for hard bugs: reproduce, hypothesize, instrument, fix, regression-test."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Process methodology: [process/debugging.md](../../process/debugging.md).
Always start by reproducing the bug in an E2E setting.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: issue)
Writes: none
Override: commit-producing skill

## Exit
- /review for a critic pass.
- /wrapup to resolve concerns and cascade docs.

## Tone
Methodical. Hypothesis first, fix second. No shotgun debugging.
