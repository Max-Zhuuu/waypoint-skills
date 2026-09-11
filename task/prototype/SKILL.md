---
name: prototype
description: "Build throwaway prototypes to flesh out a design. Duplicate existing components, wire to variant switcher."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Three branches: logic (TUI/CLI), UI (variant switcher), design (toggle panel).

Does NOT: create standalone artifacts when existing components can be duplicated. Always wire to a variant switcher so design changes are compared in context, not isolation.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns
Writes: none (prototype artifacts are throwaway)

## Exit
- Prototype is self-contained. Extract the chosen variant or discard all.

## Tone
Fast and rough. Prototypes validate ideas, not ship code.
