---
name: design
description: "Create and evolve a design system through three waves: Soul, Tokens, Proof."
status: stable
---

Design system coordinator. Routes to right wave based on project state.

Waves:
- [WAVE-1-SOUL.md](phases/wave-1-soul.md) - product's design identity
- [WAVE-2-TOKENS.md](phases/wave-2-tokens.md) - distill soul into token system
- [WAVE-3-PROOF.md](phases/wave-3-proof.md) - stress-test tokens on real screens

Read [reference/context-gate.md](reference/context-gate.md) before proceeding. Gate on understanding, not file existence.
Read [reference/mode-detection.md](reference/mode-detection.md) for greenfield/resume/retrofit/evolve.
Read [reference/guardrails.md](reference/guardrails.md) for prototyping philosophy and fixation detection.

Between waves, checkpoint: "Wave {N} complete. {summary}. Ready for wave {N+1}?"

Does NOT write component code. Produces design tokens and system specs.

## Exit
- /prototype to validate decisions visually.
- /create to implement tokens in code.
- On exit, run the shared exit sequence: see [the exit sequence](../../internals/engagement/README.md#exit-sequence).

## Engagement
See engagement protocol.
