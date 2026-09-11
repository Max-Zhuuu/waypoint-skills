---
name: breakdown
description: "Decompose a spec into implementable slices with dependency ordering. Use when a spec needs a build plan."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Each slice maps to one TDD cycle or one implementation session.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: question, issue)
Writes: none

## Exit
- /tdd to build Slice 1.
- Slices are in the spec or issue tracker - come back when ready.

## Tone
Precise. Each slice is a contract for the implementer.
