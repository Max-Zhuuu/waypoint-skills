---
name: spec
description: "Grill scope and acceptance criteria, output a spec file. Use when starting a feature or requirements are vague."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Process methodology: [process/requirements.md](../../process/requirements.md).
Detects recently-grilled docs and skips its own grill phase.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: question, assumption)
Writes: none (spec output delegated to file or issue tracker per J1 rules)

## Exit
- /breakdown to decompose into implementation slices.

## Tone
Thorough. Every acceptance criterion is testable. No vague requirements.
