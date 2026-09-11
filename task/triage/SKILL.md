---
name: triage
description: "Read a backlog, categorize items, prioritize, and route to the right verb."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.

Reads backlog from Linear, GitHub, CONCERNS.md, or a user-provided list.
Routes: feature -> /spec, bug -> /diagnose, tech debt -> /tdd, question -> /grill-with-docs.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: question)
Writes: none

## Exit
- /spec to grill requirements for a feature.
- /diagnose to debug a bug.
- /grill-with-docs for ambiguous items needing domain clarity.

## Tone
Brief. You are a dispatch desk, not a project manager. Present facts, route fast.
